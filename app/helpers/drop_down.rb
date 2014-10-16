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

  STAFF_STATUS = [
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

  KIN_TYPE = [
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

  QUALIFICATION_LEVEL = [
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
    [ "Others",4 ]
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

  LOAN_TYPE = [
           #  Displayed       stored in db
           [ "Perumahan", 1 ],
           [ "Kenderaan", 2 ],
           [ "Komputer", 3 ],
           [ "Other", 4 ],
           [ "None", 99 ]
  ]
  
  STAFF_COURSE_TYPE = [
       #  Displayed       stored in db
       [ "In-House",              5 ],
       [ "External Short Course",10 ],
       [ "Seminar",              15 ],
       [ "Certificate",          20 ],
       [ "Diploma/Others",       25 ]
  ]
  
  DURATION_TYPE = [
       #  Displayed       stored in db
       [ "Days",  1 ],
       [ "Months",2 ],
       [ "Years", 3 ]
  ]

  LOCATION_CATEGORIES = [
         #  Displayed       stored in db
         [ "building" , 1 ],
         [ "student residence" , 4 ],
         [ "floor"    , 2 ],
         [ "room"     , 3 ]
  ]


  LOCATION_TYPE = [
          #  Displayed       stored in db
          [ "Staff Unit",   1 ],
          [ "Student Unit",      6 ],
          [ "Bed (Student-Female)",   2 ],
          [ "Bed (Student-Male)",     8 ],
          [ "Facility",          3 ],
          [ "Staff Area",        4 ],
          [ "Public Area",       5 ],
          [ "Utilities",         7 ],
          [ "Other",             9 ]
  ]

  ASSETTYPE = [
             #  Displayed       stored in db
             ["H",1],
             ["I",2]
  ]
  

  DOCUMENT_CATEGORY = [
          #  Displayed       stored in db
          [ "Surat",      "1" ],
          [ "Memo",       "2" ],
          [ "Pekeliling", "3" ],
          [ "Lain-Lain",  "4" ],
          [ "e-Mel",      "5" ]
   ]
 
   DOCUMENT_ACTION = [
           #  Displayed       stored in db
           [ "Segera","1" ],
           [ "Biasa","2" ],
           [ "Makluman", "3" ]
    ]

    EXAMTYPE = [
              #  Displayed       stored in db
                 [ "Peperiksaan Pertengahan Semester",      "M" ],
                 [ "Peperiksaan Akhir Semester",            "F" ],
                 [ "Peperiksaan Ulangan",                   "R" ]
    ]
    PAPERTYPE =[
             #  Displayed       stored in db
                ["Template",        0],
                ["Complete Exam",  1]
    ]
       
    QTYPE = [
           #  Displayed       stored in db
           [ "Objektif - MCQ", "MCQ" ],
           [ "Subjektif - MEQ","MEQ" ],
           [ "Subjektif - SEQ","SEQ" ],
           [ "ACQ",            "ACQ" ],
           [ "OSCI",           "OSCI" ],
           [ "OSCII",          "OSCII" ],
           [ "OSCE",           "OSCE"],  #10Apr2013-newly added - to confirm
           [ "OSPE",           "OSPE"],  #10Apr2013-newly added - to confirm
           [ "VIVA",           "VIVA"],   #10Apr2013-newly added - to confirm
           [ "Objektif - True/False",  "TRUEFALSE"]   #10Apr2013-newly added - to confirm          
    ]
   
    QCATEGORY = [
            #  Displayed       stored in db
            [ "Recall","Recall" ],
            [ "Comprehension","Comprehension" ],
            [ "Application", "Application" ],
            [ "Analysis", "Analysis" ],
            [ "Synthesis", "Synthesis" ]
     ]
    
     QLEVEL = [
              #  Displayed       stored in db
              [ "(R) Easy | Mudah","1" ],
              [ "(S) Intermediate | Pertengahan","2" ],
              [ "(T) Difficult | Sukar", "3" ]
     ]
  
     QSTATUS = [
         #  Displayed       stored in db
         [ "Created","Created" ],
         [ "Submitted","Submitted" ],
         [ "Edited", "Edited" ],
         [ "Approved", "Approved" ],
         [ "Reject at College", "Reject at College" ],
         [ "Sent to KKM", "Sent to KKM" ],
         [ "Re-Edit", "Re-Edit" ],
         [ "Rejected", "Rejected" ]
    ]
     
    DAY_CHOICE = [
         #  Displayed       stored in db
         [ "Sun-Wed",  1 ],
         [ "Thurs",    2 ]
    ]
    
    DAY_LIST = [
            #  Displayed       stored in db
            ["Monday",     1],
            ["Tuesday",    2],
            ["Wednesday",  3],
            ["Thursday",   4]
    ]
    
    CLASS_METHOD = [
            #  Displayed       stored in db
            [I18n.t('training.programme.kuliah'),     1],
            [I18n.t('training.programme.tutorial'),    2],
            [I18n.t('training.programme.amali'),  3]
    ]
    
    COURSE_STATUS = [
         #  Displayed       stored in db
         [ I18n.t('training.programme.major'),     1 ],
         [ I18n.t('training.programme.minor'),     2 ],
         [ I18n.t('training.programme.elective'),  3 ]
    ]

    DURATION_TYPES = [
         #  Displayed       stored in db
         [ I18n.t('training.programme.hours'),      0 ],
         [ I18n.t('training.programme.days'),       1 ],
         [ I18n.t('training.programme.weeks'),      7 ],
         [ I18n.t('training.programme.months'),     30 ],
         [ I18n.t('training.programme.years'),      365 ]
    ]
    
    COURSE_TYPES_PROG =  [
      # Displayed	stored in db
      ['Diploma','Diploma'],
      ['Pos Basik','Pos Basik'],
      ['Diploma Lanjutan','Diploma Lanjutan']
    ]
    
    COURSE_TYPES_SUB = [
      # Displayed	stored in db
       [I18n.t('training.programme.semester'),'Semester'],
       [I18n.t('training.programme.subject'),'Subject'],
       [I18n.t('training.programme.commonsubject'),'Commonsubject'],
       [I18n.t('training.programme.topic'),'Topic'],
       [I18n.t('training.programme.subtopic'), 'Subtopic']
      ]
    
    #COURSE_TYPES = [
    #   ['Diploma','Diploma'],
    #   ['Pos Basik','Pos Basik'],
    #   ['Diploma Lanjutan','Diploma Lanjutan'],
    #   [I18n.t('training.programme.semester'),'Semester'],
    #   [I18n.t('training.programme.subject'),'Subject'],
    #  [I18n.t('training.programme.commonsubject'),'Commonsubject'],
    #   [I18n.t('training.programme.topic'),'Topic'],
     #  [I18n.t('training.programme.subtopic'), 'Subtopic']
     # ]
    
    COURSE_TYPES = [
       ['Diploma','Diploma'],
       ['Pos Basik','Pos Basik'],
       ['Diploma Lanjutan','Diploma Lanjutan'],
       ['Semester','Semester'],
       ['Subject','Subject'],
       ['Commonsubject','Commonsubject'],
       ['Topic','Topic'],
       ['Subtopic', 'Subtopic']
      ]

    LECTURE_TIME = [
      [I18n.t('training.programme.hours'), 1],
      [I18n.t('training.programme.minutes'), 2]
      ]
    
    LOGTYPE = [
	# Displayed        stored in db
        [ I18n.t('staff_attendance.log_in'),        'I' ],
        [ I18n.t('staff_attendance.log_out'),      'O' ]
      ]
    
    TRIGGER_STATUS = [
	# Displayed       stored in db
        [ I18n.t('staff_attendance.outstation'), 1],
        [ I18n.t('staff_attendance.official'), 2],
        [ I18n.t('staff_attendance.forgot'), 3],
        [ I18n.t('staff_attendance.early_late'), 4],
        [ I18n.t('staff_attendance.others'), 5]
      ]
    
    # library resources (book)
    
  LOAN = [
        #  Displayed       stored in db 
        [ I18n.t('library.book.open_shelf') ],
        [ I18n.t('library.book.red_spot')]
  ]
  
  LANGUAGE = [
        #  Displayed       stored in db
        [ "English", "EN" ],
        [ "Bahasa Malaysia", "ms_MY" ],
        [ I18n.t('library.book.others'), "lain"]
  ]
  
  MEDIA = [
         #  Displayed       stored in db
         [ I18n.t('library.book.book2'),1 ],
         [ I18n.t('library.book.magazine'),2 ],
         [ "DVD", 3 ],
         [ "CD", 4]
  ]
  
  STATUS = [
          #  Displayed       stored in db
          [ I18n.t('library.book.available'),1 ],
          [ I18n.t('library.book.on_loan'),2 ],
          [ I18n.t('library.book.fixed'), 3 ],
          [ I18n.t('library.book.disposed'), 4 ]
] 
  CATSOURCE = [
          #  Displayed       stored in db
          [ "Perustakaan Negara",1 ],
          [ "Amazon.com",2 ],
          [ "Others",3 ]
]
  
  
  #student discipline cases  
   STATUS = [
         #  Displayed       stored in db
         [ "New","New" ],
         [ "Open","Open" ],
         [ "No Case","No Case" ],
         [ "Closed", "Closed" ],
         [ "Refer to BPL", "Refer to BPL" ]
    ]
    
    STAFFLEAVETYPE = [
             #  Displayed       stored in db
             [ "Cuti Rehat",1 ],
             [ "Cuti Sakit",2],
             [ "Cuti Tanpa Rekod",3 ],
             [ "Cuti Separuh Gaji",4 ],
             [ "Cuti Tanpa Gaji",5 ],
             [ "Cuti Bersalin",6 ],
             [ "Cuti Haji",7 ]
     ]
     
     FILTERS = [
       {:scope => "relevant",        :label => "All"},
       {:scope => "mine",       :label => "My Leave"},
       {:scope => "forsupport", :label => "For My Support"},
       {:scope => "forapprove", :label => "For My Approval"}
       ]
      
   #evactivities (staff appraisal)
   EVACT = [
          #  Displayed       stored in db
          [ "Komuniti","1" ],
          [ "Jabatan","2" ],
          [ "Daerah", "3" ],
          [ "Negeri", "4" ],
          [ "Negera", "5" ],
          [ "Antarabangsa", "9" ]
   ]
   
   #ptcourse
    COURSE_TYPE = [
       #  Displayed       stored in db
       [ "In-House",              5 ],
       [ "External Short Course",10 ],
       [ "Seminar",              15 ],
       [ "Certificate",          20 ],
       [ "Diploma/Others",       25 ],
   ]
  
   DUR_TYPE = [
       #  Displayed       stored in db
       [ "Days",  1 ],
       [ "Months",2 ],
       [ "Years", 3 ],
   ]
   
   #Assetcategory
  ASSETTYPE = [
             #  Displayed       stored in db
             ["Harta",1],
             ["Inventory",2]
  ]
   
end
