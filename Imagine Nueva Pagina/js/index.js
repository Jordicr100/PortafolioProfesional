const toggleButton = document.getElementsByClassName('boton-toggle')[0]
const barraNavLinks = document.getElementsByClassName('nav-links')[0]

toggleButton.addEventListener('click', () => {
    barraNavLinks.classList.toggle('active')
})

var acc = document.getElementsByClassName("acordeon")
var i;

for (i=0; i < acc.length; i++){
    acc[i].addEventListener("click", function(){

        var panel = this.nextElementSibling;
        if (panel.style.display == "block"){
            panel.style.display = "none";
        } else {
            panel.style.display = "block";
        }
    });
}

for (i = 0; i < acc.length; i++){
    acc[i].addEventListener("click", function(){
        var panel = this.nextElementSibling;
        if(panel.style.maxHeight) {
            panel.style.maxHeight = null;
        } else {
            panel.style.maxHeight = panel.scrollHeight + "px"
        }
    });
}