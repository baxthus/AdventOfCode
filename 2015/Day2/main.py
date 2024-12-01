def calculate_wrapping_paper(dimensions):
    l, w, h = map(int, dimensions.split('x'))
    surface_area = 2*l*w + 2*w*h + 2*h*l
    smallest_side = min(l*w, w*h, h*l)
    return surface_area + smallest_side

def total_wrapping_paper():
    total = 0
    with open('input.txt') as f:
        for line in f:
            total += calculate_wrapping_paper(line.strip())
    return total

def calculate_ribbon(dimensions):
    l, w, h = map(int, dimensions.split('x'))
    volume = l*w*h
    smallest_perimeter = min(2*l+2*w, 2*w+2*h, 2*h+2*l)
    return volume + smallest_perimeter

def total_ribbon():
    total = 0
    with open('input.txt') as f:
        for line in f:
            total += calculate_ribbon(line.strip())
    return total

print(f"Total square feet of wrapping paper: {total_wrapping_paper()}")
print(f"Total feet of ribbon: {total_ribbon()}")