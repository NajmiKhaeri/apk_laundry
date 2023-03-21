<?php
require 'koneksi.php';

if (isset($_GET['id'])) {
    $id_transaksi = $_GET['id'];
    $query_detail = "DELETE FROM detail_transaksi WHERE id_transaksi = $id_transaksi";
    mysqli_query($conn, $query_detail);

    $query_transaksi = "DELETE FROM transaksi WHERE id_transaksi = $id_transaksi";
    mysqli_query($conn, $query_transaksi);
    header('location: transaksi.php?msg=Transaksi berhasil dihapus');
} else {
    header('location: transaksi.php?msg=Gagal menghapus transaksi');
}
