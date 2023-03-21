-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 15, 2023 at 11:56 PM
-- Server version: 10.4.24-MariaDB
-- PHP Version: 8.1.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `najmi_laundry`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_pelanggan` (IN `nama` VARCHAR(228), IN `alamat` TEXT, IN `jenis_kelamin` ENUM('L','P'), IN `no_hp` VARCHAR(30))   BEGIN
	INSERT INTO pelanggan (nama_pelanggan, alamat_pelanggan, jenis_kelamin, no_hp) VALUES (nama, alamat, jenis_kelamin, no_hp);
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `data`
-- (See below for the actual view)
--
CREATE TABLE `data` (
`id_transaksi` int(11)
,`outlet_id` int(11)
,`kode_invoice` varchar(228)
,`id_pelanggan` int(11)
,`tgl` datetime
,`batas_waktu` datetime
,`tgl_pembayaran` datetime
,`diskon` double
,`status` enum('baru','proses','selesai','diambil')
,`status_bayar` enum('dibayar','belum')
,`id_user` int(11)
);

-- --------------------------------------------------------

--
-- Table structure for table `detail_transaksi`
--

CREATE TABLE `detail_transaksi` (
  `id_detail` int(11) NOT NULL,
  `id_transaksi` int(11) NOT NULL,
  `id_paket` int(11) NOT NULL,
  `qty` double NOT NULL,
  `total_harga` double NOT NULL,
  `total_bayar` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Triggers `detail_transaksi`
--
DELIMITER $$
CREATE TRIGGER `transaksi_update` AFTER INSERT ON `detail_transaksi` FOR EACH ROW BEGIN
    DECLARE total_bayar DOUBLE;
    DECLARE total_harga DOUBLE;
    DECLARE diskon DOUBLE;
    DECLARE status_bayar ENUM('dibayar', 'belum');
    
    SELECT SUM(total_harga) INTO total_harga FROM detail_transaksi WHERE id_transaksi = NEW.id_transaksi;
    SET total_bayar = total_harga;
    
    SELECT diskon INTO diskon FROM transaksi WHERE id_transaksi = NEW.id_transaksi;
    IF diskon IS NOT NULL THEN
        SET total_bayar = total_harga - (total_harga * diskon / 100);
    END IF;
    
    SET status_bayar = 'belum';
    IF NEW.total_bayar >= total_bayar THEN
        SET status_bayar = 'dibayar';
    END IF;
    
    UPDATE transaksi SET
        tgl = NOW(),
        batas_waktu = NOW() + INTERVAL 3 DAY,
        diskon = diskon,
        status_bayar = status_bayar
    WHERE id_transaksi = NEW.id_transaksi;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `outlet`
--

CREATE TABLE `outlet` (
  `id_outlet` int(11) NOT NULL,
  `nama_outlet` varchar(228) CHARACTER SET utf8mb4 DEFAULT NULL,
  `alamat_outlet` text CHARACTER SET utf8mb4 DEFAULT NULL,
  `telp_outlet` varchar(15) CHARACTER SET utf8mb4 DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `outlet`
--

INSERT INTO `outlet` (`id_outlet`, `nama_outlet`, `alamat_outlet`, `telp_outlet`) VALUES
(1, 'outlet 1', 'cirebon', '081234');

--
-- Triggers `outlet`
--
DELIMITER $$
CREATE TRIGGER `hapus_detail_transaksi` BEFORE DELETE ON `outlet` FOR EACH ROW BEGIN
   DELETE FROM detail_transaksi WHERE id_outlet = OLD.id_outlet;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `paket_cuci`
--

CREATE TABLE `paket_cuci` (
  `id_paket` int(11) NOT NULL,
  `nama_paket` enum('standar kiloan','standar selimut','standar karpet','standar boneka','kilat kiloan','kilat selimut','kilat karpet','kilat boneka') NOT NULL,
  `harga` int(11) NOT NULL,
  `outlet_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `paket_cuci`
--

INSERT INTO `paket_cuci` (`id_paket`, `nama_paket`, `harga`, `outlet_id`) VALUES
(1, 'standar kiloan', 7000, 1);

-- --------------------------------------------------------

--
-- Table structure for table `pelanggan`
--

CREATE TABLE `pelanggan` (
  `id_pelanggan` int(11) NOT NULL,
  `nama_pelanggan` varchar(228) NOT NULL,
  `alamat_pelanggan` text NOT NULL,
  `jenis_kelamin` enum('L','P') NOT NULL,
  `no_hp` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `pelanggan`
--

INSERT INTO `pelanggan` (`id_pelanggan`, `nama_pelanggan`, `alamat_pelanggan`, `jenis_kelamin`, `no_hp`) VALUES
(2, 'Najmi', 'Jawa', 'L', '0892345678910'),
(3, 'Arrisa', 'Kuningan', 'L', '08123456789'),
(4, 'Iki', 'Majalengka', 'P', '0819377');

-- --------------------------------------------------------

--
-- Table structure for table `transaksi`
--

CREATE TABLE `transaksi` (
  `id_transaksi` int(11) NOT NULL,
  `outlet_id` int(11) DEFAULT NULL,
  `kode_invoice` varchar(228) CHARACTER SET utf8mb4 DEFAULT NULL,
  `id_pelanggan` int(11) DEFAULT NULL,
  `tgl` datetime DEFAULT NULL,
  `batas_waktu` datetime DEFAULT NULL,
  `tgl_pembayaran` datetime DEFAULT NULL,
  `diskon` double DEFAULT NULL,
  `status` enum('baru','proses','selesai','diambil') CHARACTER SET utf8mb4 DEFAULT NULL,
  `status_bayar` enum('dibayar','belum') CHARACTER SET utf8mb4 DEFAULT NULL,
  `id_user` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id_user` int(11) NOT NULL,
  `nama_user` varchar(228) CHARACTER SET utf8mb4 DEFAULT NULL,
  `username` varchar(228) CHARACTER SET utf8mb4 DEFAULT NULL,
  `password` varchar(228) CHARACTER SET utf8mb4 DEFAULT NULL,
  `outlet_id` int(11) DEFAULT NULL,
  `role` enum('admin','kasir') CHARACTER SET utf8mb4 DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id_user`, `nama_user`, `username`, `password`, `outlet_id`, `role`) VALUES
(1, 'najmikap', 'najmi', '202cb962ac59075b964b07152d234b70', 1, 'admin');

-- --------------------------------------------------------

--
-- Structure for view `data`
--
DROP TABLE IF EXISTS `data`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `data`  AS SELECT `transaksi`.`id_transaksi` AS `id_transaksi`, `transaksi`.`outlet_id` AS `outlet_id`, `transaksi`.`kode_invoice` AS `kode_invoice`, `transaksi`.`id_pelanggan` AS `id_pelanggan`, `transaksi`.`tgl` AS `tgl`, `transaksi`.`batas_waktu` AS `batas_waktu`, `transaksi`.`tgl_pembayaran` AS `tgl_pembayaran`, `transaksi`.`diskon` AS `diskon`, `transaksi`.`status` AS `status`, `transaksi`.`status_bayar` AS `status_bayar`, `transaksi`.`id_user` AS `id_user` FROM `transaksi` WHERE `transaksi`.`id_transaksi` = 1111  ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `detail_transaksi`
--
ALTER TABLE `detail_transaksi`
  ADD PRIMARY KEY (`id_detail`),
  ADD KEY `id_transaksi` (`id_transaksi`),
  ADD KEY `id_paket` (`id_paket`);

--
-- Indexes for table `outlet`
--
ALTER TABLE `outlet`
  ADD PRIMARY KEY (`id_outlet`);

--
-- Indexes for table `paket_cuci`
--
ALTER TABLE `paket_cuci`
  ADD PRIMARY KEY (`id_paket`),
  ADD KEY `outlet_id` (`outlet_id`);

--
-- Indexes for table `pelanggan`
--
ALTER TABLE `pelanggan`
  ADD PRIMARY KEY (`id_pelanggan`);

--
-- Indexes for table `transaksi`
--
ALTER TABLE `transaksi`
  ADD PRIMARY KEY (`id_transaksi`),
  ADD KEY `id_user` (`id_user`),
  ADD KEY `id_pelanggan` (`id_pelanggan`),
  ADD KEY `outlet_id` (`outlet_id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id_user`),
  ADD KEY `outlet_id` (`outlet_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `detail_transaksi`
--
ALTER TABLE `detail_transaksi`
  MODIFY `id_detail` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `outlet`
--
ALTER TABLE `outlet`
  MODIFY `id_outlet` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `paket_cuci`
--
ALTER TABLE `paket_cuci`
  MODIFY `id_paket` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `pelanggan`
--
ALTER TABLE `pelanggan`
  MODIFY `id_pelanggan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `transaksi`
--
ALTER TABLE `transaksi`
  MODIFY `id_transaksi` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id_user` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `detail_transaksi`
--
ALTER TABLE `detail_transaksi`
  ADD CONSTRAINT `detail_transaksi_ibfk_1` FOREIGN KEY (`id_transaksi`) REFERENCES `transaksi` (`id_transaksi`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `detail_transaksi_ibfk_2` FOREIGN KEY (`id_paket`) REFERENCES `paket_cuci` (`id_paket`) ON UPDATE CASCADE;

--
-- Constraints for table `paket_cuci`
--
ALTER TABLE `paket_cuci`
  ADD CONSTRAINT `paket_cuci_ibfk_1` FOREIGN KEY (`outlet_id`) REFERENCES `outlet` (`id_outlet`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `paket_cuci_ibfk_2` FOREIGN KEY (`outlet_id`) REFERENCES `outlet` (`id_outlet`);

--
-- Constraints for table `transaksi`
--
ALTER TABLE `transaksi`
  ADD CONSTRAINT `transaksi_ibfk_4` FOREIGN KEY (`id_user`) REFERENCES `user` (`id_user`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `transaksi_ibfk_5` FOREIGN KEY (`id_pelanggan`) REFERENCES `pelanggan` (`id_pelanggan`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `transaksi_ibfk_6` FOREIGN KEY (`outlet_id`) REFERENCES `outlet` (`id_outlet`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `user`
--
ALTER TABLE `user`
  ADD CONSTRAINT `user_ibfk_1` FOREIGN KEY (`outlet_id`) REFERENCES `outlet` (`id_outlet`) ON DELETE SET NULL ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
