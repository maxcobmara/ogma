module StaffsHelper



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

TOS = [
     #  Displayed       stored in db
     [ "Persekutuan","p" ],
     [ "Negeri","n" ]   
]

PENSION = [
     #  Displayed       stored in db
     [ "Berpencen", "1"],
     [ "Pilihan KWSP", "2"],
     [ "Belum Memilih", "3"],
     [ "Tidak Layak Memilih","4"]

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

GENDER = [
      #  Displayed       stored in db
      [ "Male","1"],
      [ "Female","2"]
]


end
