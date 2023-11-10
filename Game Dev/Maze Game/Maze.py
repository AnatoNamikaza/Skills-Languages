import pygame
import random

# Initialize pygame
pygame.init()

# Set the dimensions of the game window
WIDTH = 800
HEIGHT = 600

# Set the colors
BLACK = (0, 0, 0)
WHITE = (255, 255, 255)
RED = (255, 0, 0)
GREEN = (0, 255, 0)
BLUE = (0, 0, 255)

# Set the size of the maze cells
CELL_SIZE = 40

# Set the number of rows and columns in the maze
NUM_ROWS = HEIGHT // CELL_SIZE
NUM_COLS = WIDTH // CELL_SIZE

# Create the maze grid
maze = [[0] * NUM_COLS for _ in range(NUM_ROWS)]

# Maze generation using recursive backtracking
def generate_maze(curr_row, curr_col):
    directions = [(0, 1), (1, 0), (0, -1), (-1, 0)]
    random.shuffle(directions)

    for dr, dc in directions:
        new_row, new_col = curr_row + 2 * dr, curr_col + 2 * dc
        if 0 <= new_row < NUM_ROWS and 0 <= new_col < NUM_COLS and maze[new_row][new_col] == 0:
            maze[curr_row + dr][curr_col + dc] = 1
            maze[new_row][new_col] = 1
            generate_maze(new_row, new_col)

# Set the starting and ending positions
start_pos = (0, 0)
end_pos = (NUM_COLS - 1, NUM_ROWS - 1)

# Generate the maze
generate_maze(0, 0)

# Set up the player position
player_pos = list(start_pos)

# Set up the game window
window = pygame.display.set_mode((WIDTH, HEIGHT))
pygame.display.set_caption("Maze Game")

# Game loop
running = True
while running:
    # Handle events
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False

    # Move the player with arrow keys
    keys = pygame.key.get_pressed()
    if keys[pygame.K_UP] and player_pos[1] > 0 and maze[player_pos[1] - 1][player_pos[0]] == 1:
        player_pos[1] -= 1
    if keys[pygame.K_DOWN] and player_pos[1] < NUM_ROWS - 1 and maze[player_pos[1] + 1][player_pos[0]] == 1:
        player_pos[1] += 1
    if keys[pygame.K_LEFT] and player_pos[0] > 0 and maze[player_pos[1]][player_pos[0] - 1] == 1:
        player_pos[0] -= 1
    if keys[pygame.K_RIGHT] and player_pos[0] < NUM_COLS - 1 and maze[player_pos[1]][player_pos[0] + 1] == 1:
        player_pos[0] += 1

    # Check if the player reached the end
    if player_pos == list(end_pos):
        print("You win!")
        running = False

    # Clear the screen
    window.fill(BLACK)

    # Draw the maze
    for row in range(NUM_ROWS):
        for col in range(NUM_COLS):
            if maze[row][col] == 1:
                pygame.draw.rect(window, WHITE, (col * CELL_SIZE, row * CELL_SIZE, CELL_SIZE, CELL_SIZE))

    # Draw the start and end positions
    pygame.draw.rect(window, GREEN, (start_pos[0] * CELL_SIZE, start_pos[1] * CELL_SIZE, CELL_SIZE, CELL_SIZE))
    pygame.draw.rect(window, RED, (end_pos[0] * CELL_SIZE, end_pos[1] * CELL_SIZE, CELL_SIZE, CELL_SIZE))

    # Draw the player
    pygame.draw.rect(window, BLUE, (player_pos[0] * CELL_SIZE, player_pos[1] * CELL_SIZE, CELL_SIZE, CELL_SIZE))

    # Update the display
    pygame.display.update()

# Quit the game
pygame.quit()
