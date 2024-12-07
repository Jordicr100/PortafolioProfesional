const radios = document.getElementsByName('opcion_menu');
var perfInfo = document.getElementById('perfil_profesional');
var misInfo = document.getElementById('mision_info');
var visInfo = document.getElementById('vision_info');
var valInfo = document.getElementById('valores_info');
var contInfo = document.getElementById("contact_info");
// Function to check which radio button is selected
function getSelectedRadio() {
    for (const radio of radios) {
        if (radio.checked) {
            return radio.value; // Return the value of the selected radio button
        }
    }
    return null; // Return null if no radio button is selected
}

// Add an event listener to the form to detect changes
document.querySelector('form').addEventListener('change', () => {
    switch (getSelectedRadio()){
        case 'perfil':
            visInfo.style.display = "none";
            perfInfo.style.display = "block";
            misInfo.style.display = "none";
            valInfo.style.display = "none";
            contInfo.style.display = "none";
            break;
        case 'valores':
            visInfo.style.display = "none";
            perfInfo.style.display = "none";
            misInfo.style.display = "none";
            valInfo.style.display = "block";
            contInfo.style.display = "none";
            break;
        case 'vision':
            visInfo.style.display = "block";
            perfInfo.style.display = "none";
            misInfo.style.display = "none";
            valInfo.style.display = "none";
            contInfo.style.display = "none";
            break;
        case 'mision':
            visInfo.style.display = "none";
            perfInfo.style.display = "none";
            misInfo.style.display = "block";
            valInfo.style.display = "none";
            contInfo.style.display = "none";
            break;
        case 'contact':
            visInfo.style.display = "none";
            perfInfo.style.display = "none";
            misInfo.style.display = "none";
            valInfo.style.display = "none";
            contInfo.style.display = "block";
            break;
        default:
            console.log(getSelectedRadio())
    }
});



