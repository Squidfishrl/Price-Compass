const ctx = document.getElementById('myChart');

new Chart(ctx, {
	type: 'line',
		data: {
		labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
		datasets: [{
			label: 'Price',
			data: [12, 19, 3, 5, 2, 3, 5, 6, 7, 8],
			borderWidth: 1,
			tension: 0.2
		}]
	},
	options: {
		scales: {
			y: {
			beginAtZero: true
			}
		}
	}
});