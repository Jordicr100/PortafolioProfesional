create database panaderia
go

use panaderia
Select @@SERVERNAME
--Tablas de la base de datos
CREATE TABLE Clientes (
    id_cliente INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(255) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
);
CREATE TABLE Productos (
    id_producto INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion TEXT,
    precio DECIMAL(10, 2) NOT NULL,
    cantidad_stock INT NOT NULL,
    categoria VARCHAR(50)
);
CREATE TABLE LogErrores (
    id_error INT PRIMARY KEY IDENTITY(1,1),
    fecha DATETIME DEFAULT GETDATE(),
    mensaje_error NVARCHAR(MAX)
);

--Procedimientos Almacenados

ALTER PROCEDURE InsertarProducto
    @Nombre VARCHAR(100),
    @Descripcion TEXT,
    @Precio DECIMAL(10, 2),
    @CantidadStock INT,
    @Categoria VARCHAR(50),
    @Estado INT OUTPUT,
    @Mensaje NVARCHAR(MAX) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ErrorMessage NVARCHAR(MAX);
    DECLARE @ErrorSeverity INT;
    DECLARE @ErrorState INT;

    CREATE TABLE #Resultado (
        id_producto INT
    );

    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

    BEGIN TRY
        BEGIN TRANSACTION;
        
        IF @Nombre IS NULL OR @Precio IS NULL OR @CantidadStock IS NULL
        BEGIN
            SET @Estado = 400;
            SET @Mensaje = 'Faltan parámetros obligatorios.';
            THROW 50000, @Mensaje, 1;
        END

        INSERT INTO Productos (nombre, descripcion, precio, cantidad_stock, categoria)
        OUTPUT INSERTED.id_producto INTO #Resultado
        VALUES (@Nombre, @Descripcion, @Precio, @CantidadStock, @Categoria);

        COMMIT TRANSACTION;

        SET @Estado = 200;
        SET @Mensaje = 'Producto insertado exitosamente.';
    END TRY
    BEGIN CATCH
        SELECT 
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();
        
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        IF @Estado IS NULL OR @Estado != 400
        BEGIN
            SET @Estado = 500;
        END

        SET @Mensaje = @ErrorMessage;

        INSERT INTO LogErrores (mensaje_error) VALUES (@ErrorMessage);
    END CATCH;
    
    DROP TABLE #Resultado;
END;


ALTER PROCEDURE ActualizarProducto
    @IdProducto INT,
    @Nombre VARCHAR(100),
    @Descripcion TEXT,
    @Precio DECIMAL(10, 2),
    @CantidadStock INT,
    @Categoria VARCHAR(50),
    @Estado INT OUTPUT,
    @Mensaje NVARCHAR(MAX) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @ErrorMessage NVARCHAR(MAX);
    DECLARE @ErrorSeverity INT;
    DECLARE @ErrorState INT;

    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (SELECT 1 FROM Productos WHERE id_producto = @IdProducto)
        BEGIN
            SET @Estado = 404;
            SET @Mensaje = 'El producto no existe.';
            THROW 50000, @Mensaje, 1;
        END
        
        UPDATE Productos
        SET 
            nombre = @Nombre,
            descripcion = @Descripcion,
            precio = @Precio,
            cantidad_stock = @CantidadStock,
            categoria = @Categoria
        WHERE id_producto = @IdProducto;

        COMMIT TRANSACTION;

        SET @Estado = 200;
        SET @Mensaje = 'Producto actualizado exitosamente.';
    END TRY
    BEGIN CATCH
        SELECT 
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();
        
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        INSERT INTO LogErrores (mensaje_error) VALUES (@ErrorMessage);
        
        IF @Estado IS NULL OR @Estado != 404
        BEGIN
            SET @Estado = 500;
        END
        SET @Mensaje = @ErrorMessage;
    END CATCH;
END;

CREATE PROCEDURE getProducto
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT *
    FROM Productos;
END;

ALTER PROCEDURE getProductoPorId
    @IdProducto INT,
    @Estado INT OUTPUT,
    @Mensaje NVARCHAR(MAX) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ErrorMessage NVARCHAR(MAX);
    DECLARE @ErrorSeverity INT;
    DECLARE @ErrorState INT;

	
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Verificar si el producto existe
        IF NOT EXISTS (SELECT 1 FROM Productos WHERE id_producto = @IdProducto)
        BEGIN
            SET @Estado = 404; -- Código de estado para "No encontrado"
            SET @Mensaje = 'El producto no existe.';
            THROW 50000, @Mensaje, 1; -- Lanzar un error personalizado
        END
        
        -- Seleccionar el producto
        SELECT *
        FROM Productos
        WHERE id_producto = @IdProducto;

        COMMIT TRANSACTION;

        SET @Estado = 200; -- Código de estado para éxito
        SET @Mensaje = 'Producto encontrado exitosamente.';
    END TRY
    BEGIN CATCH
        SELECT 
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();
        
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        INSERT INTO LogErrores (mensaje_error) VALUES (@ErrorMessage);
        
        IF @Estado IS NULL OR @Estado != 404
        BEGIN
            SET @Estado = 500; -- Código de estado para error no controlado
        END
        SET @Mensaje = @ErrorMessage;
    END CATCH;
END;


ALTER PROCEDURE InsertarCliente
    @Nombre VARCHAR(100),
    @Direccion VARCHAR(255),
    @Telefono VARCHAR(20),
    @Email VARCHAR(100),
    @Estado INT OUTPUT,
    @Mensaje NVARCHAR(MAX) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ErrorMessage NVARCHAR(MAX);
    DECLARE @ErrorSeverity INT;
    DECLARE @ErrorState INT;

    CREATE TABLE #Resultado (
        id_cliente INT
    );

    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF @Nombre IS NULL
        BEGIN
            SET @Estado = 400;
            SET @Mensaje = 'Falta el nombre del cliente.';
            THROW 50000, @Mensaje, 1;
        END

        INSERT INTO Clientes (nombre, direccion, telefono, email)
        OUTPUT INSERTED.id_cliente INTO #Resultado
        VALUES (@Nombre, @Direccion, @Telefono, @Email);

        COMMIT TRANSACTION;

        SET @Estado = 200;
        SET @Mensaje = 'Cliente insertado exitosamente.';
    END TRY
    BEGIN CATCH
        SELECT 
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();
        
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        IF @Estado IS NULL OR @Estado != 400
        BEGIN
            SET @Estado = 500;
        END

        SET @Mensaje = @ErrorMessage;

        INSERT INTO LogErrores (mensaje_error) VALUES (@ErrorMessage);
    END CATCH;
    
    DROP TABLE #Resultado;
END;


ALTER PROCEDURE ActualizarCliente
    @IdCliente INT,
    @Nombre VARCHAR(100),
    @Direccion VARCHAR(255),
    @Telefono VARCHAR(20),
    @Email VARCHAR(100),
    @Estado INT OUTPUT,
    @Mensaje NVARCHAR(MAX) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @ErrorMessage NVARCHAR(MAX);
    DECLARE @ErrorSeverity INT;
    DECLARE @ErrorState INT;

    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (SELECT 1 FROM Clientes WHERE id_cliente = @IdCliente)
        BEGIN
            SET @Estado = 404;
            SET @Mensaje = 'El cliente no existe.';
            THROW 50000, @Mensaje, 1;
        END
        
        UPDATE Clientes
        SET 
            nombre = @Nombre,
            direccion = @Direccion,
            telefono = @Telefono,
            email = @Email
        WHERE id_cliente = @IdCliente;

        COMMIT TRANSACTION;

        SET @Estado = 200;
        SET @Mensaje = 'Cliente actualizado exitosamente.';
    END TRY
    BEGIN CATCH
        SELECT 
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();
        
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        INSERT INTO LogErrores (mensaje_error) VALUES (@ErrorMessage);
        
        IF @Estado IS NULL OR @Estado != 404
        BEGIN
            SET @Estado = 500;
        END
        SET @Mensaje = @ErrorMessage;
    END CATCH;
END;

CREATE PROCEDURE getCliente
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT *
    FROM Clientes;
END;

ALTER PROCEDURE getClientePorId
    @IdCliente INT,
    @Estado INT OUTPUT,
    @Mensaje NVARCHAR(MAX) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ErrorMessage NVARCHAR(MAX);
    DECLARE @ErrorSeverity INT;
    DECLARE @ErrorState INT;

	
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Verificar si el cliente existe
        IF NOT EXISTS (SELECT 1 FROM Clientes WHERE id_cliente = @IdCliente)
        BEGIN
            SET @Estado = 404; -- Código de estado para "No encontrado"
            SET @Mensaje = 'El cliente no existe.';
            THROW 50000, @Mensaje, 1; -- Lanzar un error personalizado
        END
        
        -- Seleccionar el cliente
        SELECT *
        FROM Clientes
        WHERE id_cliente = @IdCliente;

        COMMIT TRANSACTION;

        SET @Estado = 200; -- Código de estado para éxito
        SET @Mensaje = 'Cliente encontrado exitosamente.';
    END TRY
    BEGIN CATCH
        SELECT 
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();
        
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        INSERT INTO LogErrores (mensaje_error) VALUES (@ErrorMessage);
        
        IF @Estado IS NULL OR @Estado != 404
        BEGIN
            SET @Estado = 500; -- Código de estado para error no controlado
        END
        SET @Mensaje = @ErrorMessage;
    END CATCH;
END;

--PRUEBAS DE LOS PROCEDIMIENTOS

DECLARE @Estado INT;
DECLARE @Mensaje NVARCHAR(MAX);

EXEC InsertarProducto
    @Nombre = 'Pan Integral',
    @Descripcion = 'Pan de trigo integral',
    @Precio = 2.50,
    @CantidadStock = 100,
    @Categoria = 'Panadería',
    @Estado = @Estado OUTPUT,
    @Mensaje = @Mensaje OUTPUT;

SELECT @Estado AS Estado, @Mensaje AS Mensaje;
Select * from Productos

DECLARE @Estado INT;
DECLARE @Mensaje NVARCHAR(MAX);

EXEC InsertarCliente
    @Nombre = 'Juan Pérez',
    @Direccion = 'Calle Falsa 123',
    @Telefono = '12345678',
    @Email = 'juan.perez@example.com',
    @Estado = @Estado OUTPUT,
    @Mensaje = @Mensaje OUTPUT;

SELECT @Estado AS Estado, @Mensaje AS Mensaje;
Select * from Clientes

DECLARE @Estado INT;
DECLARE @Mensaje NVARCHAR(MAX);

EXEC InsertarProducto
    @Nombre = NULL, -- Nombre es obligatorio
    @Descripcion = 'Pan de maíz',
    @Precio = 1.75,
    @CantidadStock = 50,
    @Categoria = 'Panadería',
    @Estado = @Estado OUTPUT,
    @Mensaje = @Mensaje OUTPUT;

SELECT @Estado AS Estado, @Mensaje AS Mensaje;

DECLARE @Estado INT;
DECLARE @Mensaje NVARCHAR(MAX);

EXEC InsertarCliente
    @Nombre = NULL,
    @Direccion = 'Calle Falsa 123',
    @Telefono = '12345678',
    @Email = 'juan.perez@example.com',
    @Estado = @Estado OUTPUT,
    @Mensaje = @Mensaje OUTPUT;

SELECT @Estado AS Estado, @Mensaje AS Mensaje;
Select * from Clientes

--Prueba Actualizar
DECLARE @Estado INT;
DECLARE @Mensaje NVARCHAR(MAX);

EXEC ActualizarProducto 
    @IdProducto = 1,
    @Nombre = 'Pan Integral',
    @Descripcion = 'Pan integral con semillas',
    @Precio = 25.50,
    @CantidadStock = 100,
    @Categoria = 'Panadería',
    @Estado = @Estado OUTPUT,
    @Mensaje = @Mensaje OUTPUT;

SELECT @Estado, @Mensaje;
SELECT * FROM Productos

DECLARE @Estado INT;
DECLARE @Mensaje NVARCHAR(MAX);

EXEC ActualizarCliente 
    @IdCliente = 1,
    @Nombre = 'Juan Perez',
    @Direccion = 'Calle Falsa 123',
    @Telefono = '555-1234',
    @Email = 'juan.perez@example.com',
    @Estado = @Estado OUTPUT,
    @Mensaje = @Mensaje OUTPUT;

SELECT @Estado, @Mensaje;
SELECT * FROM Clientes

DECLARE @Estado INT;
DECLARE @Mensaje NVARCHAR(MAX);

EXEC ActualizarCliente 
    @IdCliente = 50, -- ID De un cliente que no existe
    @Nombre = 'Juan Perez',
    @Direccion = 'Calle Falsa Para probar la actualizacion erronea',
    @Telefono = '555-1234',
    @Email = 'juan@example.com',
    @Estado = @Estado OUTPUT,
    @Mensaje = @Mensaje OUTPUT;

SELECT @Estado, @Mensaje;
SELECT * FROM Clientes

--Consulta para obtener Cliente existente
DECLARE @Estado INT;
DECLARE @Mensaje NVARCHAR(MAX);

EXEC getClientePorId 
    @IdCliente = 1,  -- Suponiendo que existe un cliente con ID 1
    @Estado = @Estado OUTPUT,
    @Mensaje = @Mensaje OUTPUT;

-- Ver los resultados
SELECT @Estado AS Estado, @Mensaje AS Mensaje;

--Consulta para obtener Producto existente
DECLARE @Estado INT;
DECLARE @Mensaje NVARCHAR(MAX);

EXEC getProductoPorId 
    @IdProducto = 1,  -- Suponiendo que existe un producto con ID 1
    @Estado = @Estado OUTPUT,
    @Mensaje = @Mensaje OUTPUT;

-- Ver los resultados
SELECT @Estado AS Estado, @Mensaje AS Mensaje;

--Consulta con producto inexistente

DECLARE @Estado INT;
DECLARE @Mensaje NVARCHAR(MAX);

EXEC getProductoPorId 
    @IdProducto = 4,  -- Suponiendo que existe un producto con ID 1
    @Estado = @Estado OUTPUT,
    @Mensaje = @Mensaje OUTPUT;

-- Ver los resultados
SELECT @Estado AS Estado, @Mensaje AS Mensaje;