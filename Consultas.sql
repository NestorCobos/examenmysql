-- 1 Consulta productos mas vendidos

SELECT p.nombre, c.nombre AS categoria, SUM(d.cantidad) AS total_vendido
FROM detalle_pedido_productos d
JOIN productos p ON d.producto_id = p.id
JOIN categorias c ON p.categoria_id = c.id
GROUP BY p.id, p.nombre, c.nombre
ORDER BY total_vendido DESC;

-- 2 Consulta ingresos por combos

SELECT co.nombre, SUM(d.cantidad * d.precio_unitario) AS ingresos_totales
FROM detalle_pedido_combos d
JOIN combos co ON d.combo_id = co.id
GROUP BY co.id, co.nombre;

-- 3 Consulta por pedidos realizados para recoger vs comer en la pizzeria

SELECT tipo_pedido, COUNT(*) AS cantidad_pedidos
FROM pedidos
GROUP BY tipo_pedido;

-- 4 Consulta por total de productos vendidos por categoria

SELECT c.nombre AS categoria, SUM(d.cantidad) AS total_productos
FROM detalle_pedido_productos d
JOIN productos p ON d.producto_id = p.id
JOIN categorias c ON p.categoria_id = c.id
GROUP BY c.id, c.nombre;

-- 5 Consulta de promedio de pizzas por cliente

SELECT cl.nombre, AVG(sub.pizzas_por_pedido) AS promedio_pizzas
FROM clientes cl
JOIN (
    SELECT p.cliente_id, p.id AS pedido_id, SUM(dt.cantidad) AS pizzas_por_pedido
    FROM pedidos p
    JOIN detalle_pedido_productos dt ON p.id = dt.pedido_id
    JOIN productos pr ON dt.producto_id = pr.id
    JOIN categorias c ON pr.categoria_id = c.id
    WHERE c.nombre = 'Pizzas'
    GROUP BY p.cliente_id, p.id
) sub ON cl.id = sub.cliente_id
GROUP BY cl.id, cl.nombre;

-- 6 Consulta por todal de ventas por el dia de la semana

SELECT DAYNAME(fecha_hora) AS dia_semana, SUM(total) AS ventas_totales
FROM pedidos
GROUP BY dia_semana
ORDER BY FIELD(dia_semana, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');

-- 7 Consulta por total de panzarottis con adicion de queso

SELECT SUM(d.cantidad) AS panzarottis_con_queso
FROM detalle_pedido_productos d
JOIN productos p ON d.producto_id = p.id
JOIN categorias c ON p.categoria_id = c.id
JOIN detalle_pedido_adiciones da ON d.id = da.detalle_producto_id
JOIN adiciones a ON da.adicion_id = a.id
WHERE c.nombre = 'Panzarottis' AND a.nombre = 'Extra Queso';

-- 8 Consulta de pedidos que incluyen bebidas como parte de combo

SELECT DISTINCT p.id AS pedido_id, p.fecha_hora
FROM pedidos p
JOIN detalle_pedido_combos dc ON p.id = dc.pedido_id
JOIN combo_productos cp ON dc.combo_id = cp.combo_id
JOIN productos pr ON cp.producto_id = pr.id
JOIN categorias c ON pr.categoria_id = c.id
WHERE c.nombre = 'Bebidas';

-- 9 Consulta de adisiones mas solicitadas por pedidos personalizadas

SELECT a.nombre, SUM(da.cantidad) AS total_solicitadas
FROM detalle_pedido_adiciones da
JOIN adiciones a ON da.adicion_id = a.id
GROUP BY a.id, a.nombre
ORDER BY total_solicitadas DESC;

-- 10 Consulta clientes que mas han realizado mas de 5 pedidos en el ultimo mes

SELECT cl.nombre, COUNT(p.id) AS total_pedidos
FROM clientes cl
JOIN pedidos p ON cl.id = p.cliente_id
WHERE p.fecha_hora >= NOW() - INTERVAL 1 MONTH
GROUP BY cl.id, cl.nombre
HAVING COUNT(p.id) > 5;

-- 11 Consulta ingresos totales generados por productos no elaborados (bedidass,postres,etc)

SELECT SUM(d.cantidad * d.precio_unitario) AS ingresos_no_elaborados
FROM detalle_pedido_productos d
JOIN productos p ON d.producto_id = p.id
WHERE p.tipo = 'no_elaborado';

-- 12 Consulta promedio de adiciones por pedido

SELECT AVG(total_adiciones) AS promedio_adiciones
FROM (
    SELECT p.id, COUNT(da.id) AS total_adiciones
    FROM pedidos p
    LEFT JOIN detalle_pedido_productos dt ON p.id = dt.pedido_id
    LEFT JOIN detalle_pedido_adiciones da ON dt.id = da.detalle_producto_id
    GROUP BY p.id
) sub;

-- 13 Consulta total combos vendidos en el ultimo mes

SELECT co.nombre, SUM(dc.cantidad) AS total_vendidos
FROM detalle_pedido_combos dc
JOIN combos co ON dc.combo_id = co.id
JOIN pedidos p ON dc.pedido_id = p.id
WHERE p.fecha_hora >= NOW() - INTERVAL 1 MONTH
GROUP BY co.id, co.nombre;

-- 14 Consulta clientes con pedidos tanto para recoger como para consumir en el lugar

SELECT cl.id, cl.nombre
FROM clientes cl
JOIN pedidos p ON cl.id = p.cliente_id
GROUP BY cl.id, cl.nombre
HAVING COUNT(DISTINCT p.tipo_pedido) = 2;

-- 15 Consulta Total de productos personalizados con adiciones

SELECT COUNT(DISTINCT detalle_producto_id) AS productos_personalizados
FROM detalle_pedido_adiciones;

-- 16 Consulta de pedidos con mas de 3 consultas diferentes

SELECT pedido_id, COUNT(DISTINCT producto_id) AS productos_diferentes
FROM detalle_pedido_productos
GROUP BY pedido_id
HAVING COUNT(DISTINCT producto_id) > 3;

-- 17 Consulta de promedio de ingresos generados por dia

SELECT AVG(ingresos_diarios) AS promedio_ingresos_dia
FROM (
    SELECT DATE(fecha_hora) AS fecha, SUM(total) AS ingresos_diarios
    FROM pedidos
    GROUP BY DATE(fecha_hora)
) sub;

-- 18 Consulta por clientes que han pedido pizzas con adiciones en mas del 50% de sus pedidos de pizza

SELECT cl.nombre
FROM clientes cl
JOIN pedidos p ON cl.id = p.cliente_id
JOIN detalle_pedido_productos dt ON p.id = dt.pedido_id
JOIN productos pr ON dt.producto_id = pr.id
JOIN categorias c ON pr.categoria_id = c.id
WHERE c.nombre = 'Pizzas'
GROUP BY cl.id, cl.nombre
HAVING (
    SUM(CASE WHEN EXISTS (
        SELECT 1 FROM detalle_pedido_adiciones da WHERE da.detalle_producto_id = dt.id
    ) THEN 1 ELSE 0 END) / COUNT(dt.id)
) > 0.5;

-- 19 Consulta por porcentaje de ventas provenientes de productos no elavorados

SELECT 
    (SUM(CASE WHEN p.tipo = 'no_elaborado' THEN d.cantidad * d.precio_unitario ELSE 0 END) / 
    SUM(d.cantidad * d.precio_unitario)) * 100 AS porcentaje_ventas_no_elaborados
FROM detalle_pedido_productos d
JOIN productos p ON d.producto_id = p.id;

-- 20 Consulta por dia de la semana con mayor numero de pedidos para recoger

SELECT DAYNAME(fecha_hora) AS dia_semana, COUNT(*) AS total_recogidas
FROM pedidos
WHERE tipo_pedido = 'recoger'
GROUP BY dia_semana
ORDER BY total_recogidas DESC
LIMIT 1;