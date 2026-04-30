CREATE DATABASE IF NOT EXISTS smartedge;
USE smartedge;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    category VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    old_price DECIMAL(10,2),
    description TEXT,
    image_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE cart_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT DEFAULT 1,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    total DECIMAL(10,2) NOT NULL,
    delivery DECIMAL(10,2) DEFAULT 300.00,
    status VARCHAR(50) DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price_at_purchase DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

INSERT INTO products (name, category, price, old_price, description, image_url) VALUES
('Sony WH-1000XM5', 'Audio', 38500.00, 48000.00, 'Industry-leading noise cancellation, 30-hour battery, and crystal-clear call quality via multipoint Bluetooth.', 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500'),
('Apple AirPods Pro (3rd Gen)', 'Audio', 29500.00, 35000.00, 'Adaptive Transparency, personalised Spatial Audio, and up to 30 hours total battery with the charging case.', 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=500'),
('JBL Xtreme 3', 'Audio', 22000.00, 28500.00, '100W stereo with deep bass, IP67 waterproof rating, 15-hour battery life, and JBL PartyBoost connectivity.', 'https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?w=500'),
('Bose QuietComfort 45', 'Audio', 34000.00, 40000.00, 'Quiet Mode and Aware Mode switching, 24-hour battery, lightweight build, and Bose TriPort acoustic architecture.', 'https://images.unsplash.com/photo-1583394838336-acd977736f90?w=500'),
('Sennheiser HD 560S', 'Audio', 18000.00, 22000.00, 'Audiophile open-back with neutral tuning, wide soundstage, 120 ohm impedance, and an ultra-light 240g frame.', 'https://images.unsplash.com/photo-1484704849700-f032a568e944?w=500'),
('Audio-Technica AT2020USB-X', 'Audio', 16500.00, 20000.00, 'Cardioid condenser USB mic with side-address design, 24-bit/192kHz audio, and built-in headphone monitoring.', 'https://images.unsplash.com/photo-1520170350707-b2da59970118?w=500'),
('Samsung Galaxy Buds3 Pro', 'Audio', 24500.00, 30000.00, 'Intelligent ANC, 360 degree audio with head tracking, a 6-mic system for calls, and 30h total battery with case.', 'https://images.unsplash.com/photo-1631176093617-6f2a2d72b222?w=500'),
('Bose SoundLink Flex', 'Audio', 14500.00, 18000.00, 'Waterproof and floatable, PositionIQ sound technology, 12-hour battery, and a built-in speakerphone.', 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=500'),
('Samsung HW-Q600C Soundbar', 'Audio', 58000.00, 70000.00, '3.1.2ch Dolby Atmos and DTS:X, wireless subwoofer, SpaceFit Sound, and seamless Samsung TV pairing.', 'https://images.unsplash.com/photo-1545454675-3531b543be5d?w=500'),

('Apple MacBook Pro 14 M3 Pro', 'Laptops', 245000.00, 280000.00, 'M3 Pro chip with 12-core CPU, 18GB unified memory, 18-hour battery, and a stunning Liquid Retina XDR display.', 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?auto=format&fit=crop&w=500&q=80'),
('Dell XPS 15 2024', 'Laptops', 198000.00, 230000.00, 'Intel Core Ultra 9, 32GB DDR5 RAM, RTX 4060, 15.6 inch OLED 3.5K touch display, and 86Whr battery.', 'https://images.unsplash.com/photo-1593640408182-31c70c8268f5?auto=format&fit=crop&w=500&q=80'),
('ASUS ROG Strix G16', 'Laptops', 185000.00, 220000.00, 'Intel Core i9-14900HX, RTX 4070, 16GB DDR5, 16 inch QHD 240Hz display, and MUX Switch for pure GPU power.', 'https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?auto=format&fit=crop&w=500&q=80'),
('Lenovo ThinkPad X1 Carbon Gen 12', 'Laptops', 168000.00, 192000.00, 'Intel Core Ultra 7, 16GB LPDDR5, 1TB SSD, 14 inch IPS anti-glare display, and legendary ThinkPad keyboard.', 'https://images.unsplash.com/photo-1525547719571-a2d4ac8945e2?auto=format&fit=crop&w=500&q=80'),
('HP Spectre x360 14', 'Laptops', 138000.00, 158000.00, 'Intel Core Ultra 7, 2.8K OLED touch display, 360 degree hinge, included stylus, and 17-hour battery life.', 'https://images.unsplash.com/photo-1603302576837-37561b2e2302?auto=format&fit=crop&w=500&q=80'),
('Apple MacBook Air 13 M3', 'Laptops', 148000.00, 165000.00, 'M3 chip, 8GB unified memory, fanless design, 15-hour battery, and a 13.6 inch Liquid Retina display. Under 1.24kg.', 'https://images.unsplash.com/photo-1541807084-5c52b6b3adef?auto=format&fit=crop&w=500&q=80'),
('Acer Nitro V 15 2024', 'Laptops', 72000.00, 90000.00, 'Intel Core i5-13420H, RTX 4050, 16GB DDR5, 15.6 inch FHD 144Hz IPS display, great performance at its price.', 'https://images.unsplash.com/photo-1484788984921-03950022c9ef?auto=format&fit=crop&w=500&q=80'),
('Microsoft Surface Laptop 6', 'Laptops', 128000.00, 148000.00, 'Intel Core Ultra 5, 16GB RAM, 13.5 inch PixelSense display, Copilot+ PC features, and up to 19-hour battery.', 'https://images.unsplash.com/photo-1611186871525-7ea7ab1ec1f7?auto=format&fit=crop&w=500&q=80'),
('HP 255 G10', 'Laptops', 38000.00, 50500.00, 'AMD Ryzen 5 7520U, 8GB DDR5, 512GB SSD, 15.6 inch FHD display, a reliable everyday workhorse at a great price.', 'https://images.unsplash.com/photo-1531297484001-80022131f5a1?auto=format&fit=crop&w=500&q=80'),

('Apple iPhone 16 Pro', 'Smartphones', 145000.00, 162000.00, 'A18 Pro chip, titanium design, 48MP camera system with 5x optical zoom, and Action Button with iOS 18.', 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=500&q=80'),
('Samsung Galaxy S25 Ultra', 'Smartphones', 175000.00, 198000.00, 'Snapdragon 8 Elite, built-in S Pen, 200MP main camera, 5000mAh battery, and Galaxy AI features.', 'https://images.unsplash.com/photo-1610945415295-d9bbf067e59c?auto=format&fit=crop&w=500&q=80'),
('Google Pixel 9 Pro', 'Smartphones', 118000.00, 135000.00, 'Google Tensor G4 chip, Best Take and Magic Eraser AI photography tools, 7 years of OS updates guaranteed.', 'https://images.unsplash.com/photo-1580910051074-3eb694886505?auto=format&fit=crop&w=500&q=80'),
('Xiaomi 14 Ultra', 'Smartphones', 128000.00, 150000.00, 'Leica-tuned quad camera, Snapdragon 8 Gen 3, 90W HyperCharge, and a 6.73 inch LTPO AMOLED display.', 'https://images.unsplash.com/photo-1574944985070-8f3ebc6b79d2?auto=format&fit=crop&w=500&q=80'),
('Samsung Galaxy Z Fold 6', 'Smartphones', 195000.00, 220000.00, '7.6 inch inner display, titanium frame, Snapdragon 8 Gen 3, Galaxy AI multitasking, and IPX8 water resistance.', 'https://images.unsplash.com/photo-1567581935884-3349723552ca?auto=format&fit=crop&w=500&q=80'),
('OnePlus 12', 'Smartphones', 82000.00, 100000.00, 'Snapdragon 8 Gen 3, Hasselblad-tuned triple camera, 100W SuperVOOC charging, and 50W wireless charging.', 'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?auto=format&fit=crop&w=500&q=80'),
('Tecno Camon 30 Pro', 'Smartphones', 28000.00, 35000.00, '50MP AI triple camera, 6.78 inch AMOLED 144Hz display, 5000mAh battery with 45W fast charging.', 'https://images.unsplash.com/photo-1601784551446-20c9e07cdbdb?auto=format&fit=crop&w=500&q=80'),
('Apple iPhone 15', 'Smartphones', 98000.00, 114000.00, 'A16 Bionic chip, Dynamic Island, 48MP main camera with 2x Telephoto, USB-C, and all-day battery life.', 'https://images.unsplash.com/photo-1616348436168-de43ad0db179?auto=format&fit=crop&w=500&q=80'),
('Infinix Note 40 Pro', 'Smartphones', 18500.00, 23500.00, 'Helio G99 Ultimate, 108MP OIS camera, 6.78 inch curved AMOLED display, and 100W wired fast charging.', 'https://images.unsplash.com/photo-1598327105854-c8674faddf79?auto=format&fit=crop&w=500&q=80'),

('Logitech MX Keys S', 'Accessories', 12500.00, 15000.00, 'Smart illuminated keys, multi-device Bluetooth pairing for up to 3 devices, and a rechargeable 10-day battery.', 'https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?auto=format&fit=crop&w=500&q=80'),
('Logitech MX Master 3S', 'Accessories', 9800.00, 11800.00, '8K DPI sensor, MagSpeed electromagnetic scroll wheel, silent clicks, and ergonomic design for all-day use.', 'https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?auto=format&fit=crop&w=500&q=80'),
('Anker 733 GaNPrime PowerBank', 'Accessories', 6500.00, 8000.00, '10000mAh with a built-in USB-C wall charger, 65W fast charging, and charges two devices simultaneously.', 'https://images.unsplash.com/photo-1623126908029-58cb08a2b272?auto=format&fit=crop&w=500&q=80'),
('Razer DeathAdder V3', 'Accessories', 7200.00, 8500.00, '30K DPI Focus Pro optical sensor, 90-hour battery life, ultra-lightweight 63g frame, and HyperSpeed wireless.', 'https://images.unsplash.com/photo-1586210579191-33b45e38fa2c?auto=format&fit=crop&w=500&q=80'),
('Apple MagSafe Charger 2m', 'Accessories', 4200.00, 4700.00, '15W fast wireless charging for iPhone 12 and later, magnetic alignment, braided cable, and USB-C connector.', 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?auto=format&fit=crop&w=500&q=80'),
('Targus CityGear 15.6 Backpack', 'Accessories', 5800.00, 7200.00, 'Water-resistant shell, dedicated laptop compartment, hidden back pocket, USB pass-through, and ergonomic straps.', 'https://images.unsplash.com/photo-1547082299-de196ea013d6?auto=format&fit=crop&w=500&q=80'),
('Baseus 65W GaN 3-Port Charger', 'Accessories', 2800.00, 3600.00, 'Two USB-C and one USB-A port, 65W total output, GaN technology for a compact size, charges laptop and phone at once.', 'https://images.unsplash.com/photo-1615750173854-f95a534b4e22?auto=format&fit=crop&w=500&q=80'),
('Logitech C920 HD Pro Webcam', 'Accessories', 8200.00, 10000.00, 'Full 1080p at 30fps, dual stereo microphones with noise reduction, autofocus, and universal clip for monitors.', 'https://images.unsplash.com/photo-1596558450268-9c27524ba856?auto=format&fit=crop&w=500&q=80'),
('Samsung Galaxy S25 Ultra Clear Case', 'Accessories', 1600.00, 2000.00, 'Official Samsung slim-fit case with S Pen slot, anti-yellowing material, raised edges, and MagSafe compatibility.', 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=500&q=80');
