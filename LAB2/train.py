#!/usr/bin/env python
import torch
from torchvision import transforms, models
from torch.utils.data import DataLoader
import numpy as np
import cv2
import torch.nn as nn
import torch.optim as optim
import os
from sklearn.model_selection import train_test_split
from tqdm import tqdm
from sklearn.metrics import f1_score

# Initialize lists to hold images and labels
images = []
labels = []
# Define image dimensions
IMG_SIZE = 256
# Load and preprocess cat images in color
for image_path in os.listdir("cats-and-dogs-mini-dataset/cats_set"):
    image = cv2.imread(
        os.path.join("cats-and-dogs-mini-dataset/cats_set", image_path)
    )  # Read in color
    image = cv2.resize(image, (IMG_SIZE, IMG_SIZE))
    images.append(image)
    labels.append(0)  # Label for cats

# Load and preprocess dog images in color
for image_path in os.listdir("cats-and-dogs-mini-dataset/dogs_set"):
    image = cv2.imread(
        os.path.join("cats-and-dogs-mini-dataset/dogs_set", image_path)
    )  # Read in color
    image = cv2.resize(image, (IMG_SIZE, IMG_SIZE))
    images.append(image)
    labels.append(1)  # Label for dogs

# Convert lists to NumPy arrays
images = np.array(images)
labels = np.array(labels)


# Normalize pixel values for CNN
images_normalized = images / 255.0  # Normalize to [0, 1]

# Transpose images to (N, C, H, W)
images_normalized = images_normalized.transpose((0, 3, 1, 2))

# Convert images and labels to torch tensors
images_tensor = torch.from_numpy(images_normalized).float()
labels_tensor = torch.from_numpy(labels).long()

# Split data
X_train_cnn, X_test_cnn, y_train_cnn, y_test_cnn = train_test_split(
    images_tensor, labels_tensor, test_size=0.2, random_state=42, stratify=labels_tensor
)


# Custom Dataset class
class CustomImageDataset(torch.utils.data.Dataset):
    def __init__(self, imgs, lbls, transform=None):
        self.images = imgs  # Torch tensors
        self.labels = lbls  # Torch tensors
        self.transform = transform

    def __len__(self):
        return len(self.images)

    def __getitem__(self, idx):
        img = self.images[idx]
        lbl = self.labels[idx]

        if self.transform:
            # Convert image to PIL image for transforms
            img = transforms.ToPILImage()(img)
            img = self.transform(img)

        return img, lbl


# Define transforms for data augmentation
train_transform = transforms.Compose(
    [
        transforms.RandomHorizontalFlip(),
        transforms.RandomResizedCrop(224),
        transforms.ToTensor(),
    ]
)

test_transform = transforms.Compose(
    [
        transforms.Resize(256),
        transforms.CenterCrop(224),
        transforms.ToTensor(),
    ]
)

# Create datasets
train_dataset = CustomImageDataset(X_train_cnn, y_train_cnn, transform=train_transform)
test_dataset = CustomImageDataset(X_test_cnn, y_test_cnn, transform=test_transform)

# Create dataloaders
batch_size = 32

train_loader = DataLoader(train_dataset, batch_size=batch_size, shuffle=True)
test_loader = DataLoader(test_dataset, batch_size=batch_size, shuffle=False)


# Load a pre-trained model and modify the final layer
model = models.resnet18(pretrained=True)
num_ftrs = model.fc.in_features
model.fc = nn.Linear(num_ftrs, 2)  # Assuming 2 classes: dog and cat

# Define loss function and optimizer
criterion = nn.CrossEntropyLoss()
optimizer = optim.Adam(model.parameters(), lr=0.001)

# Training the model
num_epochs = 10
early_stopping_patience = 5
best_val_f1 = float("-inf")
pochs_no_improve = 0
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
model.to(device)

for epoch in range(num_epochs):
    model.train()
    running_loss = 0.0
    pbar = tqdm(
        train_loader, total=len(train_loader), desc=f"Epoch {epoch+1}/{num_epochs}"
    )
    for i, batch in enumerate(pbar):
        inputs, labels = batch
        inputs, labels = inputs.to(device), labels.to(device)

        optimizer.zero_grad()
        outputs = model(inputs)
        loss = criterion(outputs, labels)
        loss.backward()
        optimizer.step()

        running_loss += loss.item()
        pbar.set_description(f"Epoch {epoch+1}/{num_epochs}, Loss: {loss.item():.4f}")
    model.eval()
    val_loss = 0.0
    all_preds = []
    all_labels = []
    with torch.no_grad():
        for inputs, labels in test_loader:
            inputs, labels = inputs.to(device), labels.to(device)
            outputs = model(inputs)
            loss = criterion(outputs, labels)
            val_loss += loss.item()
            _, predicted = torch.max(outputs, 1)
            all_preds.extend(predicted.cpu().numpy())
            all_labels.extend(labels.cpu().numpy())

    # Tính F1 score
    val_f1 = f1_score(all_labels, all_preds, average="micro")
    avg_val_loss = val_loss / len(test_loader)
    print(f"Validation Loss: {avg_val_loss:.4f}, Validation F1 Score: {val_f1:.4f}")
    if val_f1 > best_val_f1:
        best_val_f1 = val_f1
        torch.save(model, "dog_cat_model.pth")
        epochs_no_improve = 0
    else:
        epochs_no_improve += 1
        if epochs_no_improve >= early_stopping_patience:
            print("Early stopping!")
            break

print("Finished Training")
