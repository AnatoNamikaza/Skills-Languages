import pygame
import random
import time

# Initialize Pygame
pygame.init()
pygame.mixer.init()

# Set up the game window
window_width = 800
window_height = 600
window = pygame.display.set_mode((window_width, window_height))
pygame.display.set_caption("Space Shooter")

# Define colors
BLACK = (0, 0, 0)
WHITE = (255, 255, 255)

# Function to load and resize images
def load_and_resize_image(image_path, width, height):
    image = pygame.image.load(image_path)
    return pygame.transform.scale(image, (width, height))

# Load and resize game elements
spaceship_image = load_and_resize_image("spaceship.png", 50, 50)
obstacle_image = load_and_resize_image("obstacle.png", 50, 50)
powerup_image = load_and_resize_image("powerup.png", 50, 50)

# Set up game variables
player_speed = 5
bullet_speed = 7
obstacle_speed = 3
powerup_speed = 2
obstacle_frequency = 60  # in frames
powerup_frequency = 60 * 5  # in frames (every 5 seconds)
score = 0
lives = 3
powerup_timer = 0
bullets = []  # Initialize the list of bullets
obstacles = []  # Initialize the list of obstacles
powerup_rect = pygame.Rect(0, 0, 50, 50)  # Adjust the size as needed

# Initialize spaceship_rect at the bottom center
spaceship_rect = pygame.Rect(window_width // 2 - 25, window_height - 50, 50, 50)  # Adjust the size as needed

# Load background music
pygame.mixer.music.load('your_background_music.mp3')
pygame.mixer.music.play(-1)  # -1 means play indefinitely

# Game loop
running = True
clock = pygame.time.Clock()

font = pygame.font.Font(None, 36)

highest_score = 0  # Initialize the highest score

while running:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False

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

    # Shoot bullets
    if keys[pygame.K_SPACE]:
        bullet_rect = pygame.Rect(
            spaceship_rect.centerx - 2, spaceship_rect.top, 5, 10
        )  # Adjust the bullet size as needed
        bullets.append(bullet_rect)

    # Move bullets
    bullets = [bullet.move(0, -bullet_speed) for bullet in bullets]

    # Move obstacles
    obstacles = [obstacle.move(0, obstacle_speed) for obstacle in obstacles]

    # Move powerup
    if powerup_timer > 0:
        powerup_rect = powerup_rect.move(0, powerup_speed)
        powerup_timer -= 1
    else:
        powerup_rect.centerx = random.randint(0, window_width)
        powerup_rect.centery = -powerup_rect.height
        powerup_timer = powerup_frequency

    # Check for collisions with bullets and obstacles
    for bullet in bullets:
        for obstacle in obstacles:
            if bullet.colliderect(obstacle):
                obstacles.remove(obstacle)
                bullets.remove(bullet)
                score += 10

    # Check for collisions with spaceship and obstacles
    for obstacle in obstacles:
        if spaceship_rect.colliderect(obstacle):
            obstacles.remove(obstacle)
            lives -= 1

    # Check for collisions with spaceship and powerup
    if spaceship_rect.colliderect(powerup_rect):
        if lives < 4:
            lives += 1
        powerup_rect.centerx = random.randint(0, window_width)
        powerup_rect.centery = -powerup_rect.height
        powerup_timer = powerup_frequency

    # Remove bullets that go off the screen
    bullets = [bullet for bullet in bullets if bullet.y > 0]

    # Spawn new obstacles
    if pygame.time.get_ticks() % obstacle_frequency == 0:
        obstacle_rect = obstacle_image.get_rect()
        obstacle_rect.centerx = random.randint(0, window_width)
        obstacle_rect.centery = -obstacle_rect.height
        obstacles.append(obstacle_rect)

    # Draw game elements
    window.fill(BLACK)
    window.blit(spaceship_image, spaceship_rect)

    for bullet in bullets:
        pygame.draw.rect(window, WHITE, bullet)

    for obstacle in obstacles:
        window.blit(obstacle_image, obstacle)

    window.blit(powerup_image, powerup_rect)

    # Draw score and lives
    score_text = font.render(f"Score: {score}", True, WHITE)
    lives_text = font.render(f"Lives: {lives}", True, WHITE)

    window.blit(score_text, (10, 10))
    window.blit(lives_text, (window_width - 120, 10))

    pygame.display.flip()

    # Cap the frame rate
    clock.tick(60)

    # Check for game over
    if lives <= 0:
        running = False

# Stop the background music
pygame.mixer.music.stop()

# Game over menu
while True:
    window.fill(BLACK)

    total_score_text = font.render(f"Total Score: {score}", True, WHITE)
    highest_score_text = font.render(f"Highest Score: {highest_score}", True, WHITE)
    play_again_text = font.render("Press 'Y' to play again", True, WHITE)
    quit_text = font.render("Press 'Q' to quit", True, WHITE)

    window.blit(total_score_text, (window_width // 2 - 100, window_height // 2 - 50))
    window.blit(highest_score_text, (window_width // 2 - 120, window_height // 2))
    window.blit(play_again_text, (window_width // 2 - 150, window_height // 2 + 50))
    window.blit(quit_text, (window_width // 2 - 120, window_height // 2 + 100))

    pygame.display.flip()

    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            pygame.quit()
        elif event.type == pygame.KEYDOWN:
            if event.key == pygame.K_y:
                # Update the highest score
                if score > highest_score:
                    highest_score = score
                
                # Restart the game
                lives = 3
                score = 0
                obstacles = []
                bullets = []
                powerup_rect.centerx = random.randint(0, window_width)
                powerup_rect.centery = -powerup_rect.height
                powerup_timer = 0
                running = True
            elif event.key == pygame.K_q:
                pygame.quit()

    clock.tick(60)
