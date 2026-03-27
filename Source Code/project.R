# Load dataset
student_data <- read.csv(file.choose())


# View structure
str(student_data)

# View first few rows
head(student_data)

# Check dimensions
dim(student_data)


# Overall summary of dataset
summary(student_data)


# Mean scores
mean(student_data$math.score)
mean(student_data$reading.score)
mean(student_data$writing.score)

# Median scores
median(student_data$math.score)
median(student_data$reading.score)
median(student_data$writing.score)

# Standard deviation
sd(student_data$math.score)
sd(student_data$reading.score)
sd(student_data$writing.score)

# Mean scores grouped by gender
aggregate(cbind(math.score, reading.score, writing.score) ~ gender, data = student_data, mean)

# Select only score columns
score_data <- student_data[, c("math.score", "reading.score", "writing.score")]

# Correlation matrix
cor_matrix <- cor(score_data)

# Display correlation matrix
cor_matrix


# Math vs Reading
plot(student_data$reading.score, student_data$math.score,
     main = "Reading Score vs Math Score",
     xlab = "Reading Score",
     ylab = "Math Score")

# Math vs Writing
plot(student_data$writing.score, student_data$math.score,
     main = "Writing Score vs Math Score",
     xlab = "Writing Score",
     ylab = "Math Score")

# Reading vs Writing
plot(student_data$reading.score, student_data$writing.score,
     main = "Reading Score vs Writing Score",
     xlab = "Reading Score",
     ylab = "Writing Score")


t_test_gender_math <- t.test(math.score ~ gender, data = student_data)
t_test_gender_math

t_test_prep_reading <- t.test(reading.score ~ test.preparation.course,data = student_data)
t_test_prep_reading

t_test_lunch_writing <- t.test(writing.score ~ lunch, data = student_data)
t_test_lunch_writing


# Linear regression model 1
model1 <- lm(math.score ~ reading.score + writing.score, data = student_data)

# Summary of model
summary(model1)

# Linear regression model 2
model2 <- lm(math.score ~ reading.score + writing.score + lunch + test.preparation.course, data = student_data)
# Summary of extended model
summary(model2)


# Histogram of Math Scores
hist(student_data$math.score, main = "Distribution of Math Scores", xlab = "Math Score")

# Histogram of Reading Scores
hist(student_data$reading.score, main = "Distribution of Reading Scores", xlab = "Reading Score")

# Histogram of Writing Scores
hist(student_data$writing.score, main = "Distribution of Writing Scores", xlab = "Writing Score")

boxplot(math.score ~ gender, 
        data = student_data,
        main = "Math Score by Gender",
        xlab = "Gender",
        ylab = "Math Score")


boxplot(reading.score ~ test.preparation.course,
        data = student_data,
        main = "Reading Score by Test Preparation Course",
        xlab = "Test Preparation Course",
        ylab = "Reading Score")


# Calculate average math score by lunch type
avg_math_lunch <- aggregate(math.score ~ lunch,
                            data = student_data,
                            mean)
# Bar plot
barplot(avg_math_lunch$math.score,
        names.arg = avg_math_lunch$lunch,
        main = "Average Math Score by Lunch Type",
        xlab = "Lunch Type",
        ylab = "Average Math Score")
