import torch

x = torch.tensor([3.0, 4.0])

magnitude = torch.linalg.vector_norm(x)

print("vector:", x)
print("magnitude:", magnitude)

manual = torch.sqrt(
    x[0]**2 +
    x[1]**2
)

print("manual:", manual)
