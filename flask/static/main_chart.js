const ctx = document.getElementById('chart');

let priceChart = new Chart(ctx, {
	type: 'line',
		data: {
		labels: ['14.03', '15.03', '16.03', '17.03', '18.03', '19.03', '20.03', '21.03', '22.03', '23.03', '24.03', '25.03'],
		datasets: [{
			label: 'Цена',
			data: [2.08, 2.08, 2.08, 2, 2, 2.10, 2.05, 2.05, 2.05, 2.11],
			borderWidth: 1,
			tension: 0.2
		}]
	},
	options: {
		responsive: true,
		scales: {
			// x: {
			// 	type: 'time'
			// },
			y: {
				beginAtZero: true
			}
		},
		plugins: {
			zoom: {
				pan: {
					enabled: true,
				},
				limits: {
					// x: { min: , max:  },
					y: { min: 0, max: 100, minRange: 0.9 }
				},
				zoom: {
					wheel: {
						enabled: true
					},
					pinch: {
						enabled: true
					}
				}
			}
		}
	}
});

document.querySelector("#reset-zoom").addEventListener("click", () => {
	Chart.getChart('chart').resetZoom();
})
