import gradio as gr
import torch
from torchvision import transforms

# Determine the device
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
model = torch.load("dog_cat_model.pth")
model.to(device)
model.eval()

# Định nghĩa transform cho ảnh đầu vào
transform = transforms.Compose(
    [
        transforms.Resize(256),
        transforms.CenterCrop(224),
        transforms.ToTensor(),
    ]
)


# Hàm phân loại ảnh
def classify_image(image):
    image = transform(image).unsqueeze(0).to(device)
    with torch.no_grad():
        output = model(image)
        _, predicted = torch.max(output, 1)
    return "Dog" if predicted.item() == 1 else "Cat"


# Tạo giao diện Gradio
iface = gr.Interface(fn=classify_image, inputs=gr.Image(type="pil"), outputs="text")

# Chạy giao diện
iface.launch()
