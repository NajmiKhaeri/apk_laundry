<?php
$title = 'Edit Data Paket';
require 'koneksi.php';

$nama= [
    'standar kiloan',
    'standar selimut',
    'standar karpet',
    'standar boneka',
    'kilat kiloan',
    'kilat selimut',
    'kilat karpet',
    'kilat boneka'
];

$id = $_GET['id'];
$query = "SELECT * FROM paket_cuci WHERE id_paket = '$id'";
$queryedit = mysqli_query($conn, $query);

if (isset($_POST['btn-simpan'])) {
    $nama = $_POST['nama_paket'];
    $harga = $_POST['harga'];
    $id_outlet = $_POST['outlet_id'];

    $query = "UPDATE paket_cuci SET nama_paket = '$nama', harga = '$harga', outlet_id = '$id_outlet' WHERE id_paket = '$id'";
    $update = mysqli_query($conn, $query);
    if ($update == 1) {
        $_SESSION['msg'] = 'Berhasil mengubah data';
        header('location:paket.php');
    } else {
        $_SESSION['msg'] = 'Gagal mengubah data!!!';
        header('location:paket.php');
    }
}

require 'header.php';
?>
<div class="content">
    <div class="page-inner">
        <div class="page-header">
            <h4 class="page-title">Forms</h4>
            <ul class="breadcrumbs">
                <li class="nav-home">
                    <a href="index.php">
                        <i class="flaticon-home"></i>
                    </a>
                </li>
                <li class="separator">
                    <i class="flaticon-right-arrow"></i>
                </li>
                <li class="nav-item">
                    <a href="paket.php">Paket</a>
                </li>
                <li class="separator">
                    <i class="flaticon-right-arrow"></i>
                </li>
                <li class="nav-item">
                    <a href="#"><?= $title; ?></a>
                </li>
            </ul>
        </div>
        <div class="row">
            <div class="col-md-10">
                <div class="card">
                    <div class="card-header">
                        <div class="card-title"><?= $title; ?></div>
                    </div>
                    <?php while ($edit = mysqli_fetch_assoc($queryedit)) { ?>
                    <form action="" method="POST">
                        <div class="card-body">
                            <div class="form-group">
                                <label for="defaultSelect">Nama Paket</label>
                                <select type="text" name="nama_paket" class="form-control form-control"
                                    id="defaultSelect">
                                    <option value="standar kiloan">Standar Kiloan</option>
                                    <option value="standar selimut">Standar Selimut</option>
                                    <option value="standar karpet">Standar Karpet</option>
                                    <option value="standar boneka">Standar Boneka</option>
                                    <option value="kilat kiloan">Kilat Kiloan</option>
                                    <option value="kilat selimut">Kilat Selimut</option>
                                    <option value="kilat karpet">Kilat Karpet</option>
                                    <option value="kilat boneka">Kilat Boneka</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="">Harga</label>
                                <div class="input-group mb-3">
                                    <div class="input-group-prepend">
                                        <span class="input-group-text" id="basic-addon1">Rp</span>
                                    </div>
                                    <input type="text" class="form-control" name="harga" aria-describedby="basic-addon1"
                                        value="<?= $edit['harga']; ?>">
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="defaultSelect">Pilih Outlet</label>
                                <?php
                                    function ambildata($conn, $query)
                                    {
                                        $data = mysqli_query($conn, $query);
                                        if (mysqli_num_rows($data) > 0) {
                                            while ($row = mysqli_fetch_assoc($data)) {
                                                $hasil[] = $row;
                                            }
                                            return $hasil;
                                        }
                                    }
                                    $query2 = "SELECT * FROM outlet";
                                    $data2 = ambildata($conn, $query2);
                                    ?>
                                <select name="outlet_id" class="form-control form-control" id="defaultSelect">
                                    <?php foreach ($data2 as $outlet) : ?>
                                    <?php if ($data2['id_outlet'] == $edit['outlet_id']) : ?>
                                    <option value="<?= $outlet['id_outlet'] ?>" selected><?= $outlet['nama_outlet']; ?>
                                    </option>
                                    <?php endif ?>
                                    <option value="<?= $outlet['id_outlet'] ?>"><?= $outlet['nama_outlet']; ?></option>
                                    <?php endforeach ?>
                                </select>
                            </div>
                            <div class="card-action">
                                <button type="submit" name="btn-simpan" class="btn btn-success">Submit</button>
                                <!-- <button class="btn btn-danger">Cancel</button> -->
                                <a href="javascript:void(0)" onclick="window.history.back();"
                                    class="btn btn-danger">Batal</a>
                            </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<?php } ?>
<?php require 'footer.php'; ?>