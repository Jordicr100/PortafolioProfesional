function showLoginForm() {
    // Ocultar el formulario de inicio de sesi�n y mostrar el loader al inicio
    document.getElementById("Preloader").style.display = "flex";
    document.getElementById("loginUser").style.display = "none";
    // Obtener todos los campos de entrada
    var inputFields = document.querySelectorAll('input');

    // Aplicar estilo inicial a todos los campos
    inputFields.forEach(function (input) {
        input.style.borderBottom = '2px solid white';
    });
    // Despu�s de un tiempo simulado (por ejemplo, 2 segundos), mostrar el formulario de inicio de sesi�n y ocultar el loader
    setTimeout(function () {
        document.getElementById("Preloader").style.display = "none";
        document.getElementById("loginUser").style.display = "flex";

        var toggleIcon = $("#togglePasswordIcon");
        toggleIcon.attr("style", "color: #83C3B8;");
    }, 2000); // Cambia 2000 a la cantidad de milisegundos que quieras que dure el loader (por ejemplo, 3000 para 3 segundos)
}


document.addEventListener("DOMContentLoaded", function () {
    // Llamar a la funci�n para mostrar el formulario despu�s de que se haya cargado la p�gina
    showLoginForm();

    // Obtener los elementos relevantes del DOM
    const formLogin = document.getElementById("formLogin");
    const formPassword = document.getElementById("formPassword");
    const formRegister = document.getElementById("formRegister");
    const btnRecoverPassword = document.getElementById("btnRecoverPassword");
    const btnLogin = document.getElementById("btnLogin");
    const btnNewRegister = document.getElementById("btnNewRegister");
    const boxForm = document.querySelector(".boxForm");

    // Mostrar el formulario seg�n sea el caso y ocultar los dem�s al hacer clic en el bot�n
    btnRecoverPassword.addEventListener("click", function () {
        formLogin.style.display = "none";
        formRegister.style.display = "none";
        formPassword.style.display = "block";
        boxForm.style.height = "500px";
    });

    btnLogin.addEventListener("click", function () {
        formLogin.style.display = "block";
        formRegister.style.display = "none";
        formPassword.style.display = "none";
        boxForm.style.height = "550px";
    });

    btnNewRegister.addEventListener("click", function () {
        formLogin.style.display = "none";
        formRegister.style.display = "block";
        formPassword.style.display = "none";
        boxForm.style.height = "700px";
    });
});


// Funci�n para ocultar o mostrar la contrase�a en el formulario de inicio de sesi�n
function togglePasswordVisibility() {
    var passwordInput = document.getElementById('loginPassword');
    var toggleIcon = document.getElementById('togglePasswordIcon');

    if (passwordInput.type === 'password') {
        passwordInput.type = 'text';
        toggleIcon.setAttribute('name', 'lock-open-outline');
        toggleIcon.setAttribute("style", "color: #F3AD3D;");
    } else {
        passwordInput.type = 'password';
        toggleIcon.setAttribute('name', 'lock-closed-outline');
        toggleIcon.setAttribute("style", "color: #83C3B8;");
    }
}

// Funci�n para ocultar o mostrar la contrase�a en el formulario de registro
function togglePasswordVisibilityRegister() {
    var passwordInputRegister = document.getElementById('registerPassword');
    var togglePasswordIconRegister = document.getElementById('togglePasswordIconRegister');

    if (passwordInputRegister.type === 'password') {
        passwordInputRegister.type = 'text';
        togglePasswordIconRegister.setAttribute('name', 'lock-open-outline');
        togglePasswordIconRegister.setAttribute("style", "color: #F3AD3D;");
    } else {
        passwordInputRegister.type = 'password';
        togglePasswordIconRegister.setAttribute('name', 'lock-closed-outline');
        togglePasswordIconRegister.setAttribute("style", "color: #83C3B8;");
    }
}

// Agregar eventos click a los �conos de candado
var toggleIcon = document.getElementById('togglePasswordIcon');
toggleIcon.addEventListener('click', togglePasswordVisibility);

var togglePasswordIconRegister = document.getElementById('togglePasswordIconRegister');
togglePasswordIconRegister.addEventListener('click', togglePasswordVisibilityRegister);


function handleFileChange(event) {
    var input = event.target;
    var circleContainer = document.getElementById('circleContainer');
    var deleteIcon = document.getElementById('deleteIcon');
    input.style.display = "none";
    if (input.files && input.files[0]) {
        var reader = new FileReader();

        reader.onload = function (e) {
            circleContainer.style.backgroundImage = `url(${e.target.result})`;
            deleteIcon.style.opacity = 1;
        };

        reader.readAsDataURL(input.files[0]);
    }
}

function deleteImage() {
    var input = document.getElementById('registerPhoto');
    var circleContainer = document.getElementById('circleContainer');
    var deleteIcon = document.getElementById('deleteIcon');
    input.style.display = "flex";
    input.value = '';
    circleContainer.style.backgroundImage = '';
    deleteIcon.style.opacity = 0;
}
