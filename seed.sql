USE pizzeria_db;

-- Categorías
INSERT INTO categorias (nombre) VALUES 
('Pizzas'), ('Panzarottis'), ('Bebidas'), ('Postres'), ('Adiciones');

-- Ingredientes
INSERT INTO ingredientes (nombre) VALUES 
('Queso Mozzarella'), ('Jamón'), ('Champiñones'), ('Pepperoni'), ('Salsa de Tomate');

-- Productos
INSERT INTO productos (nombre, descripcion, precio, categoria_id, tipo) VALUES 
('Pizza Hawaiana', 'Pizza con jamón y piña', 25000.00, 1, 'elaborado'),
('Pizza Pepperoni', 'Pizza clásica con pepperoni', 28000.00, 1, 'elaborado'),
('Panzarotti Mixto', 'Panzarotti con jamón y queso', 15000.00, 2, 'elaborado'),
('Gaseosa 1.5L', 'Bebida sabor cola', 6000.00, 3, 'no_elaborado'),
('Jugo Natural', 'Jugo de fruta en agua', 5000.00, 3, 'no_elaborado'),
('Tiramisú', 'Postre italiano de café', 8000.00, 4, 'no_elaborado');

-- Relación Producto - Ingredientes
INSERT INTO producto_ingredientes (producto_id, ingrediente_id) VALUES 
(1, 1), (1, 2), (1, 5),
(2, 1), (2, 4), (2, 5),
(3, 1), (3, 2);

-- Adiciones
INSERT INTO adiciones (nombre, precio) VALUES 
('Extra Queso', 4000.00), 
('Salsa BBQ Extra', 2000.00), 
('Tocineta Extra', 5000.00);

-- Combos
INSERT INTO combos (nombre, descripcion, precio_especial) VALUES 
('Combo Familiar', 'Pizza Hawaiana + Gaseosa 1.5L', 29000.00),
('Combo Personal', 'Panzarotti Mixto + Jugo Natural', 18000.00);

-- Combo Productos
INSERT INTO combo_productos (combo_id, producto_id, cantidad) VALUES 
(1, 1, 1), (1, 4, 1),
(2, 3, 1), (2, 5, 1);

-- Clientes
INSERT INTO clientes (nombre, telefono, email, direccion) VALUES 
('Carlos Pérez', '3101234567', 'carlos@mail.com', 'Calle 10 # 5-20'),
('Ana Gómez', '3209876543', 'ana@mail.com', 'Carrera 15 # 40-12'),
('Luis Rodríguez', '3151112233', 'luis@mail.com', 'Avenida Central # 8-45');

-- Pedidos (Incluyendo fechas recientes para pruebas de último mes)
INSERT INTO pedidos (cliente_id, tipo_pedido, fecha_hora, total) VALUES 
(1, 'consumir_en_sitio', NOW() - INTERVAL 5 DAY, 34000.00),
(1, 'recoger', NOW() - INTERVAL 10 DAY, 29000.00),
(2, 'recoger', NOW() - INTERVAL 2 DAY, 33000.00),
(1, 'recoger', NOW() - INTERVAL 12 DAY, 18000.00),
(1, 'consumir_en_sitio', NOW() - INTERVAL 15 DAY, 25000.00),
(1, 'recoger', NOW() - INTERVAL 18 DAY, 28000.00),
(2, 'consumir_en_sitio', NOW() - INTERVAL 1 DAY, 30000.00);

-- Detalle Productos Pedidos
INSERT INTO detalle_pedido_productos (pedido_id, producto_id, cantidad, precio_unitario) VALUES 
(1, 1, 1, 25000.00), -- Pizza Hawaiana
(3, 2, 1, 28000.00), -- Pizza Pepperoni
(5, 1, 1, 25000.00),
(6, 2, 1, 28000.00),
(7, 3, 2, 15000.00);

-- Detalle Combos Pedidos
INSERT INTO detalle_pedido_combos (pedido_id, combo_id, cantidad, precio_unitario) VALUES 
(2, 1, 1, 29000.00),
(3, 2, 1, 18000.00),
(4, 2, 1, 18000.00);

-- Detalle Adiciones (Personalización)
INSERT INTO detalle_pedido_adiciones (detalle_producto_id, adicion_id, cantidad, precio_unitario) VALUES 
(1, 1, 1, 4000.00), -- Extra queso en Pizza del pedido 1
(2, 1, 1, 4000.00); -- Extra queso en Pizza del pedido 3