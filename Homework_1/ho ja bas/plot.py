import matplotlib.pyplot as plt
import pandas as pd

# Read the timing results
results = pd.read_csv('timing_results.txt')

# Extract data for plotting
threads = results['Threads']
trapezoidal_times = results['Trapezoidal Time (s)']
monte_carlo_times = results['Monte Carlo Time (s)']

# Plot the results
plt.figure(figsize=(10, 5))
plt.plot(threads, trapezoidal_times, marker='o', label='Trapezoidal Rule')
plt.plot(threads, monte_carlo_times, marker='o', label='Monte Carlo Integration')

# Adding titles and labels
plt.title('Timing Comparison of Trapezoidal and Monte Carlo Integration')
plt.xlabel('Number of Threads')
plt.ylabel('Average Time (s)')
plt.xticks(threads)  # Set x-ticks to thread counts
plt.legend()
plt.grid(True)

# Show the plot
#plt.savefig('timing_comparison.png')
plt.show()

