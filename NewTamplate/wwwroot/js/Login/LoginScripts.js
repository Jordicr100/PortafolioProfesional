function showLoginForm() {
    // Ocultar el formulario de inicio de sesión y mostrar el loader al inicio
    document.getElementById("Preloader").style.display = "flex";
    document.getElementById("loginUser").style.display = "none";
    // Obtener todos los campos de entrada
    var inputFields = document.querySelectorAll('input');

    // Aplicar estilo inicial a todos los campos
    inputFields.forEach(function (input) {
        input.style.borderBottom = '2px solid white';
    });
    // Después de un tiempo simulado (por ejemplo, 2 segundos), mostrar el formulario de inicio de sesión y ocultar el loader
    setTimeout(function () {
        document.getElementById("Preloader").style.display = "none";
        document.getElementById("loginUser").style.display = "flex";

        var toggleIcon = $("#togglePasswordIcon");
        toggleIcon.attr("style", "color: #83C3B8;");
    }, 2000); // Cambia 2000 a la cantidad de milisegundos que quieras que dure el loader (por ejemplo, 3000 para 3 segundos)
}


document.addEventListener("DOMContentLoaded", function () {
    // Llamar a la función para mostrar el formulario después de que se haya cargado la página
    showLoginForm();

    // Obtener los elementos relevantes del DOM
    const formLogin = document.getElementById("formLogin");
    const formPassword = document.getElementById("formPassword");
    const formRegister = document.getElementById("formRegister");
    const btnRecoverPassword = document.getElementById("btnRecoverPassword");
    const btnLogin = document.getElementById("btnLogin");
    const btnNewRegister = document.getElementById("btnNewRegister");
    const boxForm = document.querySelector(".boxForm");

    // Mostrar el formulario según sea el caso y ocultar los demás al hacer clic en el botón
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


// Función para ocultar o mostrar la contraseña en el formulario de inicio de sesión
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

// Función para ocultar o mostrar la contraseña en el formulario de registro
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

// Agregar eventos click a los íconos de candado
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
