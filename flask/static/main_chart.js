const ctx = document.getElementById('chart');
// console.log(ctx.dataset.prices);
const stores = JSON.parse(ctx.dataset.stores);


let resetZoomButton = document.querySelector('#reset-zoom');
resetZoomButton.addEventListener('click', () => {
	Chart.getChart('chart').resetZoom();
});


let minPrices = [];
let maxPrices = [];

function calcPricesForAll() {
	let allDataPoints = Object.values(stores).flatMap(store => store.map(details => details));
	let dates = new Set();
	allDataPoints.forEach(dp => dates.add(new Date(dp.date).toDateString()));
	minPrices = [];
	maxPrices = [];
	let pricesForDate;
	dates.forEach(d => {
		pricesForDate = allDataPoints.flatMap(dp => (new Date(dp.date).toDateString() === d) ? [dp.price] : []);
		minPrices.push(Math.min(...pricesForDate));
		maxPrices.push(Math.max(...pricesForDate));
	});
}

let select = document.querySelector('#store > select');
select.addEventListener('change', () => {
	let curr = select.options[select.selectedIndex].value;
	// console.log(priceChart.data.datasets[0].data);
	if (curr !== 'All') {
		priceChart.config.data.datasets = [
			{
				label: "Цена",
				data: stores[curr].map(obj => obj.price),
				borderWidth: 1,
				tension: 0.2
			}
		]
	} else {
		calcPricesForAll();

		priceChart.config.data.datasets = [
			{
				label: "Макс. цена",
				data: maxPrices,
				borderWidth: 1,
				backgroundColor: 'rgb(200, 0, 0)',
				borderColor: 'rgb(150, 0, 0)',
				tension: 0.2
			},
			{
				label: "Мин. цена",
				data: minPrices,
				borderWidth: 1,
				backgroundColor: 'rgb(0, 200, 0)',
				borderColor: 'rgb(0, 150, 0)',
				tension: 0.2
			}
		]
	}
	priceChart.update();
});

calcPricesForAll();
let priceChart = new Chart(ctx, {
	type: 'line',
	data: {
		labels: ['14.03', '15.03', '16.03', '17.03', '18.03', '19.03', '20.03', '21.03', '22.03', '23.03', '24.03', '25.03'],
		datasets: [
			{
				label: "макс. цена",
				data: minPrices, // [3.70, 3.70, 3.79, 3.79, 3.79, 3.79, 3.75, 3.75, 3.75, 3.75, 3.75, 3.70],
				borderWidth: 1,
				backgroundColor: 'rgb(200, 0, 0)',
				borderColor: 'rgb(150, 0, 0)',
				tension: 0.2
			},
			{
				label: "мин. цена",
				data: maxPrices, // [3.45, 3.40, 3.40, 3.40, 3.40, 3.40, 3.20, 3.20, 3.20, 3.30, 3.30, 3.30],
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
