
'''
004.- Determine cuál de los años 2003 o 2004 facturó más.'''

SELECT 
    Año, 
    SUM(Facturación) AS Facturación
FROM 
    (
        SELECT 
            YEAR(o.orderDate) AS Año, 
            (SELECT SUM(od.quantityOrdered * od.priceEach) 
             FROM orderdetails od 
             WHERE od.orderNumber = o.orderNumber) AS Facturación
        FROM 
            orders o
        WHERE 
            YEAR(o.orderDate) IN (2003, 2004)
    ) AS subquery
GROUP BY 
    Año
ORDER BY 
    Facturación DESC
LIMIT 1;


'''
005.- Para el año que facturó menos según (004), indiqué qué mes facturó menos.
'''
SELECT 
    Mes, 
    SUM(Facturación) AS Facturación
FROM 
    (
        SELECT 
            MONTH(o.orderDate) AS Mes, 
            (SELECT SUM(od.quantityOrdered * od.priceEach) 
             FROM orderdetails od 
             WHERE od.orderNumber = o.orderNumber) AS Facturación
        FROM 
            orders o
        WHERE 
            YEAR(o.orderDate) = 2004
    ) AS subquery
GROUP BY
    Mes
ORDER BY
    Facturación ASC
LIMIT 1;





´´'
006.- Para el año y mes de peor desempeño según (004 y 005), indique qué línea de producto se vendió menos en dinero.
'´´
SELECT 
    p.productCode, 
    p.productName, 
    SUM(od.quantityOrdered * od.priceEach) AS Facturación
FROM
    products p
    JOIN orderdetails od ON p.productCode = od.productCode
    JOIN orders o ON od.orderNumber = o.orderNumber
WHERE
    YEAR(o.orderDate) = 2004
    AND MONTH(o.orderDate) = 1
GROUP BY
    p.productCode
ORDER BY
    Facturación ASC
LIMIT 1;




'''
007.- Genere una vista que muestre la facturación por año y mes.
'
CREATE VIEW FacturaciónPorAñoMes AS
SELECT 
    YEAR(o.orderDate) AS Año, 
    MONTH(o.orderDate) AS Mes, 
    SUM(od.quantityOrdered * od.priceEach) AS Facturación
FROM
    orders o
    JOIN orderdetails od ON o.orderNumber = od.orderNumber
GROUP BY
    Año, Mes;


'''
008.- Genere un trigger que almacene en una tabla de auditoría si se cambia el contactFirstName de la tabla de customers.
'''
CREATE TABLE IF NOT EXISTS customer_audit (
    customerNumber INT,
    contactFirstName VARCHAR(50),
    fecha TIMESTAMP
);

