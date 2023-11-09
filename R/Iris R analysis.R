# Load necessary libraries
library(ggplot2)  # For data visualization
library(class)     # For k-Nearest Neighbors (KNN)

# Download the Iris dataset from UCI Machine Learning Repository
url <- "https://archive.ics.uci.edu/ml/machine-learning-databases/iris/iris.data"
iris <- read.table(url, header = FALSE, sep = ",")

# Assign column names to the dataset
colnames(iris) <- c("Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width", "Species")

# Data summary
summary(iris)

# Data visualization
ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width, color = Species)) +
  geom_point() +
  labs(title = "Iris Dataset: Sepal Length vs. Sepal Width")

# Split the data into training and testing sets
set.seed(123)
sample_indices <- sample(1:nrow(iris), nrow(iris) * 0.7)  # 70% training, 30% testing
train_data <- iris[sample_indices, ]
test_data <- iris[-sample_indices, ]

# Perform K-Nearest Neighbors (KNN) classification
k <- 3  # Number of neighbors to consider
predicted_species <- knn(train = train_data[, -5], test = test_data[, -5], cl = train_data$Species, k = k)

# Evaluate the accuracy of the KNN classifier
accuracy <- sum(predicted_species == test_data$Species) / nrow(test_data) * 100

# Print the results
print("Summary of Iris Dataset:")
print(summary(iris))

print("Accuracy of KNN Classifier:")
print(paste("Accuracy =", round(accuracy, 2), "%"))
