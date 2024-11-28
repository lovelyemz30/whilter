-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 15, 2024 at 02:39 AM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `myapp`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `admin_id` int(11) NOT NULL,
  `admin_email` varchar(255) NOT NULL,
  `admin_password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`admin_id`, `admin_email`, `admin_password`) VALUES
(1, 'admin', 'admin123');

-- --------------------------------------------------------

--
-- Table structure for table `items`
--

CREATE TABLE `items` (
  `item_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `size` varchar(255) DEFAULT NULL,
  `quantity` int(11) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `items`
--

INSERT INTO `items` (`item_id`, `name`, `price`, `description`, `image`, `size`, `quantity`) VALUES
(13, 'Short', 79.00, 'Red Short', '2.jpg', 'Large', 1),
(14, 'T-Shirt', 79.00, 'Black T-Shirt One Piece', '1.png', 'Small', 1),
(15, 'T-Shirt', 79.00, 'White-Green T-Shirt', '3.jpg', 'Large', 1),
(16, 'Hoodie', 99.00, 'Black Hoodie', '4.jpg', 'Large', 1),
(17, 'Hoodie', 99.00, 'Tiger Black Hoodie ', '5.jpg', 'Large', 1),
(18, 'Dress', 99.00, 'Blue Dress', '6.jpg', 'Large', 1),
(19, 'Polo-Shirt', 89.00, 'Navy Polo-Shirt', '7.jpg', 'Large', 1),
(20, 'Dress', 99.00, 'Yellow Dress', '8.jpg', 'Medium', 1),
(21, 'T-Shirt', 79.00, 'Black T-Shirt One Piece', '9.jpg', 'Medium', 1),
(22, 'Pants', 89.00, 'Navy Pants', '10.jpg', 'Medium', 1),
(23, 'Dress', 99.00, 'Red Dress', '14.jpg', 'Mediun', 2);

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `order_id` varchar(36) NOT NULL DEFAULT uuid(),
  `user_id` int(11) NOT NULL,
  `delivery_address` varchar(255) NOT NULL,
  `phone_number` varchar(20) NOT NULL,
  `parcel_name` varchar(255) NOT NULL,
  `cart_details` text NOT NULL,
  `shipping_option` varchar(50) NOT NULL,
  `order_total` decimal(10,2) NOT NULL,
  `payment_option` varchar(50) NOT NULL,
  `payment_details` text DEFAULT NULL,
  `total_payment` decimal(10,2) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `status` enum('pending','confirmed','delivered','deleted') NOT NULL DEFAULT 'pending'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`order_id`, `user_id`, `delivery_address`, `phone_number`, `parcel_name`, `cart_details`, `shipping_option`, `order_total`, `payment_option`, `payment_details`, `total_payment`, `created_at`, `status`) VALUES
('80d3f3db-9ce6-11ee-8525-106530131208', 1, 'asd', '123', 'asea', '[{\"item_id\":22,\"name\":\"Pants\",\"quantity\":1}]', 'LBC', 89.00, 'Cash on Delivery (COD)', NULL, 419.00, '2023-12-17 14:13:51', 'confirmed'),
('fa7e02f6-9e4e-11ee-b6b9-106530131208', 1, 'Zone Monggos, Paknaan Mandaue City, Cebu', '09322060920', 'Whilter', '[{\"item_id\":23,\"name\":\"Dress\",\"quantity\":1}]', 'NinjaVan', 99.00, 'Cash on Delivery (COD)', NULL, 179.00, '2023-12-19 09:14:14', 'deleted');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `user_name` varchar(255) NOT NULL,
  `user_email` varchar(255) NOT NULL,
  `user_password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `user_name`, `user_email`, `user_password`) VALUES
(1, 'jwhiltero', 'jwhiltero1@gmail.com', '92d26c44109a9ac64565c4379c40f5cd'),
(5, 'whilter', 'whilter@gmail.com', '98b1c25afef2a0e05a9b387717628ed2'),
(6, 'whilter12', 'whilter1@gmail.com', '3632a45957edcc03ca3ed37a3989f813');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`admin_id`);

--
-- Indexes for table `items`
--
ALTER TABLE `items`
  ADD PRIMARY KEY (`item_id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`order_id`),
  ADD UNIQUE KEY `order_id` (`order_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin`
--
ALTER TABLE `admin`
  MODIFY `admin_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `items`
--
ALTER TABLE `items`
  MODIFY `item_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
