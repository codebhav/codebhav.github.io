document.addEventListener("DOMContentLoaded", function () {
	const modal = document.getElementById("photo-modal");
	const fullImage = document.getElementById("full-size-image");
	const closeButton = document.querySelector(".close-button");
	const photoItems = document.querySelectorAll(".photo-item");

	// Open modal when clicking on a photo
	photoItems.forEach((item) => {
		const link = item.querySelector(".photo-link");
		link.addEventListener("click", function (e) {
			e.preventDefault();
			const fullImgSrc = item.getAttribute("data-full-img");
			fullImage.setAttribute("src", fullImgSrc);
			modal.style.display = "block";
			document.body.style.overflow = "hidden"; // Prevent scrolling
		});
	});

	// Close modal
	closeButton.addEventListener("click", function () {
		modal.style.display = "none";
		document.body.style.overflow = "";
	});

	// Close modal when clicking outside the image
	modal.addEventListener("click", function (e) {
		if (e.target === modal) {
			modal.style.display = "none";
			document.body.style.overflow = "";
		}
	});

	// Close modal with escape key
	document.addEventListener("keydown", function (e) {
		if (e.key === "Escape" && modal.style.display === "block") {
			modal.style.display = "none";
			document.body.style.overflow = "";
		}
	});
});
