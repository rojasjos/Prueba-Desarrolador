create database carcenter;
use carcenter;
CREATE TABLE IF NOT EXISTS Mecanico (
  `Id_mecanico` INT NOT NULL,
  `Nombre` VARCHAR(45) NULL,
  `Apellido` VARCHAR(45) NULL,
  `Tipo_documento` VARCHAR(45) NULL,
  `Num_documento` INT NULL,
  `Celular` INT NULL,
  `Direccion` VARCHAR(45) NULL,
  `Correo` VARCHAR(45) NULL,
  `Estado` VARCHAR(45) NULL,
  PRIMARY KEY (`Id_mecanico`));
  
  
  
CREATE TABLE IF NOT EXISTS Cliente (
  `Id_cliente` INT NOT NULL,
  `Nombre` VARCHAR(45) NULL,
  `Apellido` VARCHAR(45) NULL,
  `Tipo_documento` VARCHAR(45) NULL,
  `Num_documento` INT NULL,
  `Celular` INT NULL,
  `Direccion` VARCHAR(45) NULL,
  `Correo` VARCHAR(45) NULL,
  PRIMARY KEY (`Id_cliente`));
  
CREATE TABLE IF NOT EXISTS Factura (
  `Num_factura` INT NOT NULL,
  `Id_cliente` INT NULL,
  `Id_mecanico` INT NULL,
  `Fecha` DATE NULL,
  `cliente_Id_cliente` INT NOT NULL,
  `Mecanico_Id_mecanico` INT NOT NULL,
  PRIMARY KEY (`Num_factura`, `cliente_Id_cliente`, `Mecanico_Id_mecanico`),
  INDEX `fk_Factura_cliente_idx` (`cliente_Id_cliente` ASC) VISIBLE,
  INDEX `fk_Factura_Mecanico1_idx` (`Mecanico_Id_mecanico` ASC) VISIBLE,
  CONSTRAINT `fk_Factura_cliente`
    FOREIGN KEY (`cliente_Id_cliente`)
    REFERENCES Cliente (`Id_cliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Factura_Mecanico1`
    FOREIGN KEY (`Mecanico_Id_mecanico`)
    REFERENCES Mecanico (`Id_mecanico`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
;
CREATE TABLE IF NOT EXISTS Detalle (
  `Num_detalle` INT NOT NULL,
  `Id_factura` INT NULL,
  `Id_servicio` INT NULL,
  `Id_repuesto` INT NULL,
  `Cantidad` INT NULL,
  `Precio` INT NULL,
  `Factura_Num_factura` INT NOT NULL,
  `Factura_cliente_Id_cliente` INT NOT NULL,
  `Factura_Mecanico_Id_mecanico` INT NOT NULL,
  `Servicios_Id_servicio` INT NOT NULL,
  `Repuestos_Id_repuesto` INT NOT NULL,
  PRIMARY KEY (`Num_detalle`, `Factura_Num_factura`, `Factura_cliente_Id_cliente`, `Factura_Mecanico_Id_mecanico`, `Servicios_Id_servicio`, `Repuestos_Id_repuesto`),
  INDEX `fk_Detalle_Factura1_idx` (`Factura_Num_factura` ASC, `Factura_cliente_Id_cliente` ASC, `Factura_Mecanico_Id_mecanico` ASC) VISIBLE,
  INDEX `fk_Detalle_Servicios1_idx` (`Servicios_Id_servicio` ASC) VISIBLE,
  INDEX `fk_Detalle_Repuestos1_idx` (`Repuestos_Id_repuesto` ASC) VISIBLE,
  CONSTRAINT `fk_Detalle_Factura1`
    FOREIGN KEY (`Factura_Num_factura` , `Factura_cliente_Id_cliente` , `Factura_Mecanico_Id_mecanico`)
    REFERENCES Factura (`Num_factura` , `cliente_Id_cliente` , `Mecanico_Id_mecanico`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Detalle_Servicios1`
    FOREIGN KEY (`Servicios_Id_servicio`)
    REFERENCES Servicios (`Id_servicio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Detalle_Repuestos1`
    FOREIGN KEY (`Repuestos_Id_repuesto`)
    REFERENCES Repuestos (`Id_repuesto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
;

CREATE TABLE IF NOT EXISTS Servicios (
  `Id_servicio` INT NOT NULL,
  `Nombre` VARCHAR(45) NULL,
  `Precio_max` INT NULL,
  `Precio_min` INT NULL,
  PRIMARY KEY (`Id_servicio`))
;

CREATE TABLE IF NOT EXISTS Repuestos (
  `Id_repuesto` INT NOT NULL,
  `Nombre` VARCHAR(45) NULL,
  `Precio` INT NULL,
  `Stock` INT NULL,
  PRIMARY KEY (`Id_repuesto`))
;

#Consulta acumulado 100000 ultimos 60 días
Select Nombre, Apellido from Cliente as C
inner join Factura as F on C.Id_cliente = F.cliente_Id_cliente 	
inner join Detalle as D on C.Id_cliente = D.Factura_cliente_Id_cliente
where DATEDIFF(Now(), day(F.Fecha)) < 60
having sum(D.Precio*D.Cantidad) = 100000;

#Consulta 100 productos mas vendidos ultimos 30 dias
Select Nombre from Repuestos as R 	
inner join Detalle as D on R.Id_repuesto = D.Repuestos_Id_repuesto
inner join Factura as F on F.Num_factura = D.Factura_Num_factura
where DATEDIFF(Now(), day(F.Fecha)) < 30 
order by D.Cantidad
limit 100;

#Consulta mas de un mantenimento ultimos 30 dias
Select Nombre, Apellido from Cliente as C
inner join Factura as F on C.Id_cliente = F.cliente_Id_cliente 	
inner join Detalle as D on C.Id_cliente = D.Factura_cliente_Id_cliente
where DATEDIFF(Now(), day(F.Fecha)) < 30 
having count(distinct F.Num_factura) >1;


 

