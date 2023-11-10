import pygame
import random

# Initialize Pygame
pygame.init()

# Set up the game window
window_width = 800
window_height = 600
window = pygame.display.set_mode((window_width, window_height))
pygame.display.set_caption("Space Explorer")

# Define colors
BLACK = (0, 0, 0)

# Function to load and resize images
def load_and_resize_image(image_path, width, height):
    image = pygame.image.load(image_path)
    return pygame.transform.scale(image, (width, height))

# Load and resize game elements
spaceship_image = load_and_resize_image("spaceship.png", 50, 50)
spaceship_rect = spaceship_image.get_rect()
spaceship_rect.centerx = window_width // 2
spaceship_rect.centery = window_height // 2

obstacle_image = load_and_resize_image("obstacle.png", 50, 50)
obstacle_rect = obstacle_image.get_rect()
obstacle_rect.centerx = random.randint(0, window_width)
obstacle_rect.centery = random.randint(0, window_height)

powerup_image = load_and_resize_image("powerup.png", 50, 50)
powerup_rect = powerup_image.get_rect()
powerup_rect.centerx = random.randint(0, window_width)
powerup_rect.centery = random.randint(0, window_height)

# Set up game variables
player_speed = 5

# Game loop
running = True
clock = pygame.time.Clock()

while running:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False

    # Get the keys that are currently held down
    keys = pygame.key.get_pressed()

    # Update game logic
    if keys[pygame.K_LEFT]:
        spaceship_rect.x -= player_speed
    if keys[pygame.K_RIGHT]:
        spaceship_rect.x += player_speed
    if keys[pygame.K_UP]:
        spaceship_rect.y -= player_speed
    if keys[pygame.K_DOWN]:
        spaceship_rect.y += player_speed

    # Move the obstacle (for demonstration purposes)
    obstacle_rect.x += 3
    if obstacle_rect.left > window_width:
        obstacle_rect.right = 0
        obstacle_rect.centery = random.randint(0, window_height)

    # Check for collisions
    if spaceship_rect.colliderect(obstacle_rect):
        print("Collision with obstacle!")

    # Draw game elements
    window.fill(BLACK)
    window.blit(spaceship_image, spaceship_rect)
    window.blit(obstacle_image, obstacle_rect)
    window.blit(powerup_image, powerup_rect)
    pygame.display.flip()

    # Cap the frame rate
    clock.tick(60)

# Quit the game
pygame.quit()