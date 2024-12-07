document.querySelector(".nav_boton").addEventListener("click", function() {
    const bodyElement = document.getElementById("fondo_pag");
    bodyElement.classList.toggle("fondo_invert");
    
    // Guardamos el modo light or dark en el local storage
    if (bodyElement.classList.contains("fondo_invert")) {
        localStorage.setItem("mode", "invert");
    } else {
        localStorage.setItem("mode", "normal");
    }
});
// Check if a mode is saved in localStorage
window.onload = function() {
    const storedMode = localStorage.getItem("mode");
    const bodyElement = document.getElementById("fondo_pag");

    if (storedMode === "invert") {
        bodyElement.classList.add("fondo_invert");
    } else {
        bodyElement.classList.remove("fondo_invert");
    }
};
