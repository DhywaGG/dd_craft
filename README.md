# dd-crafting-v2 — Qbox Native

## Installation

Download the `dd-library` from GitHub and ensure it is started before the `dd-crafting` resource.

1. **Download dd-library**:  
   Download the library from the [GitHub repository]([https://github.com/DhywaGG/dd-library]).
   
2. **Start the library**:  
   Ensure that the `dd-library` resource is started before the `dd-crafting-v2` resource in your `server.cfg`.

3. Resource ini sudah dikonfigurasi untuk `qbx_core`, `ox_inventory`, dan `ox_target`.

4. **Ensure that folder name is `dd-crafting-v2`**

## Urutan server.cfg

```cfg
ensure ox_lib
ensure qbx_core
ensure ox_inventory
ensure ox_target
ensure dd-library
ensure dd-crafting-v2
```

Nama folder wajib `dd-crafting-v2` karena callback NUI resource asli menggunakan nama tersebut.

## Perubahan versi Qbox

- Menghapus pemanggilan `GetCoreObject()` yang tidak tersedia di Qbox native.
- Memakai modul resmi `QBX.PlayerData` pada client.
- Memakai export `qbx_core` untuk player, job, dan gang.
- Memakai `ox_inventory` untuk membaca, mengecek, menambah, serta menghapus item.
- Memeriksa kapasitas inventory sebelum memberikan hasil crafting.
- Menu resep pemain menggunakan `ox_lib` context menu.
- Detail bahan ditampilkan sebagai metadata menu dan proses memakai progress circle.
- Gambar hasil resep dimuat langsung dari `ox_inventory/web/images/<nama_item>.png`.
- Semua bahan dikurangi secara default melalui `Shared.ConsumeAllIngredients = true`.
- Jika pemberian hasil gagal, bahan yang sudah diambil otomatis dikembalikan.
- Crafting dapat dibatalkan serta mengunci gerakan, kendaraan, dan combat selama proses.

## NEW VERSION 2.0.1
1. **DATA STRUCTURE CHANGE**:  
   Because of data structure is changed you must to create again tables and items
2. **UI FIXES**: 
  Added responsive part to a crafting detail modul, builded tailwind base it will not load tailwind from cdn base  
3. **ITEM MULTIPLIER**: 
  Fixed item multiplier bug ( you can add same item with different recipes )
4. **QBOX FRAMEWORK SUPPORT**: 
  Added QBOX framework support ( only for ox_inventory rght now! )

## Client and Server Exports

You can use the following client-side and server-side exports:

```lua
-- Open a specific crafting table from an external script (Client-side)
exports['dd-crafting-v2']:OpenMenu(table_id)

-- Load the library functions for the client (Client-side)
exports['dd-library']:Load()

-- Load the library functions for the server (Server-side)
exports['dd-library']:Load()


