/* buat tabel barang lalu import file csv ke tabel barang */
create table barang (
	kode_barang varchar(10),
	sektor varchar(10),
	nama_barang varchar(100),
	tipe varchar(5),
	nama_tipe text,
	kode_lini int,
	lini varchar(30),
	kemasan text,
	
	constraint fk_barang primary key (kode_barang)
);

/* buat tabel pelanggan lalu import file csv ke tabel pelanggan */
create table pelanggan (
	id_customer varchar(10),
	level varchar(20),
	nama varchar(100),
	id_cabang_sales varchar(10),
	cabang_sales varchar(100),
	id_grup varchar(5),
	grup varchar(30),
	constraint fk_customer primary key (id_customer)
);

/* buat tabel penjualan lalu import file csv ke tabel penjualan */
create table penjualan (
id_distributor varchar(5),
	id_cabang varchar(10),
	id_invoice varchar(10),
	tanggal date,
	id_customer varchar(15),
	id_barang varchar(10),
	jumlah_barang int,
	unit varchar(10),
	harga double precision,
	mata_uang text,
	brand_i varchar(15),
	lini varchar(15),
	foreign key (id_customer) references pelanggan(id_customer),
	foreign key (id_barang) references barang(kode_barang)
);


/*membuat tabel datamart (Terdiri dari tabel base, dan tabel aggregate)*/
create table table_base as (select p.id_distributor, p.id_cabang, p.tanggal, concat(p.id_invoice,'_',p.id_barang)
						   as id_pelanggan, p.id_customer, p.jumlah_barang, p.unit, p.harga, p.mata_uang, p.brand_id,
						   p.lini,
						   pel.level, pel.nama, pel.id_cabang_sales, pel.cabang_sales, pel.id_grup, pel.grup
						   ,b.kode_barang, b.sektor, b.nama_barang, b.tipe, b.nama_tipe, b.kode_lini, b.lini, b.kemasan
							
							from penjualan as p 
							left join pelanggan as pel on p.id_customer = pel.id_customer
							left join barang as b on p.id_barang = b.kode_barang
								
						   );
						   
/*membuat tabel datamart (Terdiri dari tabel base, dan tabel aggregate)*/ 				
create  table table_aggregate as ( select tanggal, id_customer, id_distributor, brand_id, lini as brand,
						  id_pelanggan, nama_barang, kemasan, nama as customer,
						  id_cabang, cabang_sales as sales_kota, harga, 
						  sum(jumlah_barang) as total_barang_terjual,
						  avg(harga) as rata_rata_harga,
						  sum(jumlah_barang * harga) as total_penjualan from table_base
						  group by tanggal, id_customer, id_distributor, brand_id, brand, id_pelanggan,
						  nama_barang, kemasan, customer, id_cabang, sales_kota, harga);


/*https://lookerstudio.google.com/s/jFm1IPT6D0M*/