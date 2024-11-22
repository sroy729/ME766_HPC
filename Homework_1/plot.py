import matplotlib.pyplot as plt

# Read the data from the results file
intervals = []
numerical_results = []

with open('integration_results.txt', 'r') as f:
    for line in f:
        interval, result = line.split()
        intervals.append(int(interval))
        numerical_results.append(float(result))

# Analytical result of the integral of cos(x) from -π/2 to π/2
analytical_result = 2.0

# Plot the numerical results
plt.plot(intervals, numerical_results, marker='o', linestyle='-', color='b', label='Numerical Result')

# Plot the analytical result as a horizontal line
plt.axhline(y=analytical_result, color='r', linestyle='--', label='Analytical Result (2.0)')

# Add labels and title
plt.xlabel('Number of Intervals')
plt.ylabel('Integration Result')
plt.title('Comparison of Numerical and Analytical Integration Results')

# Add a legend
plt.legend()

# Show the plot
plt.show()

