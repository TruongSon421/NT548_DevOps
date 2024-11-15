import pytest
import torch
import gradio as gr
import requests


# Test mô hình huấn luyện và inference
def test_inference():
    model_path = "dog_cat_model.pth"
    try:
        # Kiểm tra mô hình có thể được load thành công từ file
        model = torch.load(model_path, weights_only=False)
    except Exception as e:
        assert False, f"Lỗi khi tải mô hình: {e}"

    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
    model.to(device)
    assert isinstance(model, torch.nn.Module), "Mô hình không phải là đối tượng PyTorch"

    # Kiểm tra inference với ảnh giả
    image = torch.randn(1, 3, 224, 224).to(device)  # Tạo ảnh giả
    output = model(image)
    assert output is not None, "Mô hình không trả về kết quả khi phân loại ảnh"
