-- --------------------------------------------------------
-- Servidor:                     127.0.0.1
-- Versão do servidor:           10.4.27-MariaDB - mariadb.org binary distribution
-- OS do Servidor:               Win64
-- HeidiSQL Versão:              12.3.0.6589
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Copiando estrutura do banco de dados para creative
CREATE DATABASE IF NOT EXISTS `` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;
USE ``;

-- Copiando estrutura para tabela creative.lc_ilegalmkt_items
CREATE TABLE IF NOT EXISTS `lc_ilegalmkt_items` (
  `id` int(255) NOT NULL AUTO_INCREMENT,
  `item_id` varchar(255) NOT NULL,
  `label` varchar(255) NOT NULL,
  `amount` varchar(255) DEFAULT NULL,
  `author_identifier` varchar(255) NOT NULL,
  `author_name` varchar(255) DEFAULT NULL,
  `phone_number` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `price` varchar(255) NOT NULL,
  `sold` tinyint(1) NOT NULL DEFAULT 0,
  `start_date` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Copiando dados para a tabela creative.lc_ilegalmkt_items: ~4 rows (aproximadamente)
INSERT INTO `lc_ilegalmkt_items` (`id`, `item_id`, `label`, `amount`, `author_identifier`, `author_name`, `phone_number`, `description`, `price`, `sold`, `start_date`) VALUES
	(6, 'xratao', 'X-Ratao', '1', '7', 'Zack', '584-679', 'Rato', '250', 1, '18/04 - 16:02'),
	(7, 'watch', 'Relógio', '1', '7', 'Zack', '584-679', 'Rejolio', '10', 1, '18/04 - 16:04'),
	(8, 'teddy', 'Teddy', '1', '7', 'Zack', '584-679', 'Sera q e o urso ou o teddy real ?', '100', 1, '18/04 - 16:05'),
	(16, 'lockpick', 'Lockpick', '1', '1', 'Lucas', '040-480', 'Usado pra abrir carros e outras coisas', '350', 0, '12/05 - 19:49'),
	(17, 'lockpick', 'Lockpick', '1', '1', 'Lucas', '040-480', 'Usado pra abrir portas e outras coisas tambem', '350', 0, '12/05 - 20:56');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
