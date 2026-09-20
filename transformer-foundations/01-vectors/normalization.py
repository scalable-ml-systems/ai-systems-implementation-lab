import torch

x = torch.tensor([3.0, 4.0])

magnitude = torch.linalg.vector_norm(x)

unit_x = x / magnitude

print("original:", x)
print("magnitude:", magnitude)

print("normalized:", unit_x)
print(
    "normalized magnitude:",
    torch.linalg.vector_norm(unit_x)
)
