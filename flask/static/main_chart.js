const ctx = document.getElementById('chart');
// console.log(ctx.dataset.prices);
const stores = JSON.parse(ctx.dataset.stores);


let resetZoomButton = document.querySelector('#reset-zoom');
resetZoomButton.addEventListener('click', () => {
	Chart.getChart('chart').resetZoom();
});


let select = document.querySelector('#store > select');
select.addEventListener('change', () => {
	let curr = select.options[select.selectedIndex].value;
	// console.log(priceChart.data.datasets[0].data);
	if (curr !== 'All') {
		// priceChart.data.datasets[0].data = prices[curr].map(obj => obj.price);
		priceChart.config.data.datasets = [
			{
				label: "Цена",
				data: stores[curr].map(obj => obj.price),
				borderWidth: 1,
				tension: 0.2
			}
		]
	} else {
		let allDataPoints = Object.values(stores).flatMap(store => store.map(details => details));
		priceChart.config.data.datasets = [
			{
				label: "макс. цена",
				data: stores['Lidl'].map(obj => obj.price),
				borderWidth: 1,
				backgroundColor: 'rgb(200, 0, 0)',
				borderColor: 'rgb(150, 0, 0)',
				tension: 0.2
			},
			{
				label: "мин. цена",
				data: stores['Billa'].map(obj => obj.price),
				borderWidth: 1,
				backgroundColor: 'rgb(0, 200, 0)',
				borderColor: 'rgb(0, 150, 0)',
				tension: 0.2
			}
		]
	}
	priceChart.update();
});


let priceChart = new Chart(ctx, {
	type: 'line',
	data: {
		labels: ['14.03', '15.03', '16.03', '17.03', '18.03', '19.03', '20.03', '21.03', '22.03', '23.03', '24.03', '25.03'],
		datasets: [
			{
				label: "макс. цена",
				data: stores['Lidl'].map(obj => obj.price),
				borderWidth: 1,
				backgroundColor: 'rgb(200, 0, 0)',
				borderColor: 'rgb(150, 0, 0)',
				tension: 0.2
			},
			{
				label: "мин. цена",
				data: stores['Billa'].map(obj => obj.price),
				borderWidth: 1,
				backgroundColor: 'rgb(0, 200, 0)',
				borderColor: 'rgb(0, 150, 0)',
				tension: 0.2
			}
		]
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
