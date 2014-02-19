module DropDown



MARITAL_STATUS = [
     #  Displayed       stored in db
     [ "Tidak Pernah Berkahwin",1 ],
     [ "Berkahwin",2 ],
     [ "Balu", 3 ],
     [ "Duda", 4],
     [ "Bercerai", 5 ],
     [ "Berpisah", 6 ],
     [ "Tiada Maklumat", 9 ]
]
   
BLOOD_TYPE = [
    #  Displayed       stored in db
    [ "O-",          "1" ],
    [ "O+",    "2" ],
    [ "A-", "3" ],
    [ "A+", "4" ],
    [ "B-", "5" ],
    [ "B+", "6" ],
    [ "AB-", "7" ],
    [ "AB+", "8" ]
    
]

BANKTYPE = [
      #  Displayed       stored in db
      [ "Simpanan",1 ],
      [ "Simpanan Bersama",2 ],
      [ "Semasa",3 ],
      [ "Simpanan Tetap",4 ],
]
       
STATECD = [
    #  Displayed       stored in db
    [ "Johor",         1 ],
    [ "Kedah",    2 ],
    [ "Kelantan", 3 ],
    [ "Melaka", 4],
    [ "Negeri Sembilan", 5 ],
    [ "Pahang", 6 ],
    [ "Pulau Pinang", 7 ],
    [ "Perak", 8 ], 
    [ "Perlis", 9 ],
    [ "Selangor", 10 ], 
    [ "Terengganu", 11 ], 
    [ "Sabah", 12 ], 
    [ "Sarawak", 13 ],
    [ "Wilayah Persekutuan Kuala Lumpur", 14 ],
    [ "Wilayah Persekutuan Labuan", 15 ],
    [ "Wilayah Persekutuan Putrajaya", 16 ],
    [ "Luar Negara", 98 ],       
]

NATIONALITY = [
     #  Displayed       stored in db
     [ "Warganegara",1],
     [ "Bukan Warganegara",2],
     [ "Penduduk Tetap", 3],
]

STATUS = [
      #  Displayed       stored in db
      [ "Tetap",1 ],
      [ "Sementara",2 ],
      [ "Sambilan",3 ]
]

APPOINTMENT = [
     #  Displayed       stored in db
     [ "Sandangan Tetap","1" ],
     [ "Sandangan Sementara","2" ],
     [ "Memangku Dengan Tujuan Naik Pangkat","3" ],
     [ "Memangku Bukan Dengan Tujuan Naik Pangkat","4" ],
     [ "Tanggung Kerja","5" ],
     [ "Sandangan Khas Untuk Penyandang","6" ],
     [ "Sandangan Sambilan","7" ],
     [ "Sandangan Khidmat Singkat","8" ]


]

APPOINTED = [
     #  Displayed       stored in db
     [ "Kementerian Kesihatan Malaysia","kkm" ],
     [ "Suruhanjaya Perkhidmatan Awam","spa" ],
     [ "Jabatan Perkhidmatan Awam","jpa" ]
     
]

HOS = [
     #  Displayed       stored in db
     [ "Suruhanjaya Perkhidmatan Awam","spa" ],
     [ "Kementerian Kesihatan Malaysia","kkm" ],
     [ "Jabatan Perkhidmatan Awam","jpa" ],
     [ "Jabatan Perpustakaan Negara","jpn" ]
     
]

KTYPE = [
        #  Displayed       stored in db
        [ "Isteri",1 ],
        [ "Suami",2 ],
        [ "Ibu", 3 ],
        [ "Bapa", 4 ],
        [ "Anak", 5 ],
        [ "Nenek", 9 ],
        [ "Saudara Kandung", 11 ],
        [ "Penjaga", 12 ],
        [ "Bekas Isteri", 13 ],
        [ "Bekas Suami", 14 ],
        [ "Penjamin I", 98 ],
        [ "Penjamin II", 99 ]
 ]
 

PENSION = [
     #  Displayed       stored in db
     [ "Berpencen", "1"],
     [ "Pilihan KWSP", "2"],
     [ "Belum Memilih", "3"],
     [ "Tidak Layak Memilih","4"]

]

QTYPE = [
     #  Displayed       stored in db
     [ "Sekolah Rendah", 17 ],
     [ "PMR/SRP dan setaraf", 16],
     [ "SPM/SPVM dan setaraf", 15 ],
     [ "Senior Cambridge Cert", 14 ],
     [ "STPM dan setaraf", 13 ],
     [ "Sijil", 12 ],
     [ "Diploma", 11 ],
     [ "Diploma Lanjutan", 10 ],
     [ "Diploma Lepasan Ijazah", 9 ],
     [ "Sarjana Muda", 8 ],
     [ "Sarjana Muda Kepujian", 7 ],
     [ "Sarjana Persuratan", 6 ],
     [ "Sarjana Sastera", 5 ],
     [ "Sarjana Sains", 4 ],
     [ "Sarjana Perubatan", 3 ],
     [ "Lepasan Sarjana",2 ],
     [ "Doktor Falsafah (Ph.D)",1 ],
     [ "Lain Lain", 99 ]
]

UNIFORM = [
      #  Displayed       stored in db
      [ "Dibekalkan/Tidak dibekalkan", "1" ],
      [ "Tarikh Akhir di beri", "2" ],
      [ "Elaun Pakaian Panas/Pakaian Istiadat", "3" ]


]

RACE = [
      #  Displayed       stored in db
      [ "Malay",1 ],
      [ "Chinese",2 ],
      [ "India",3 ],
      [ "Others",4 ],
]

RELIGION = [
      #  Displayed       stored in db
      [ "Islam",1],
      [ "Buddha",2 ],
      [ "Hindu",3 ],
      [ "Others",4 ],
]

TOS = [
     #  Displayed       stored in db
     [ "Persekutuan","p" ],
     [ "Negeri","n" ]   
]

GENDER = [
      #  Displayed       stored in db
      [ "Male","1"],
      [ "Female","2"]
]

LTYPE = [
         #  Displayed       stored in db
         [ "Perumahan", 1 ],
         [ "Kenderaan", 2 ],
         [ "Komputer", 3 ],
         [ "Other", 4 ],
         [ "None", 99 ]
]

LOCATION_CATEGORIES = [
       #  Displayed       stored in db
       [ "building" , 1 ],
       [ "floor"    , 2 ],
       [ "room"     , 3 ]
 ]


LOCATION_TYPE = [
        #  Displayed       stored in db
        [ "Staff Residence",   1 ],
        [ "Student Room",      6 ],
        [ "Bed (Student-Female)",   2 ],
        [ "Bed (Student-Male)",     8 ],
        [ "Facility",          3 ],
        [ "Staff Area",        4 ],
        [ "Public Area",       5 ],
        [ "Other",             7 ]
]


end
