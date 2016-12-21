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
  
  POSITION_STATUS = [
        #  Displayed       stored in db
        [ "Hakiki", 1],
        [ "Kontrak", 2],
        [ "KUP",3]
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
  
#   STAFF_COURSE_TYPE = [
#        #  Displayed       stored in db
#        [ "In-House",              5 ],
#        [ "External Short Course",10 ],
#        [ "Seminar",              15 ],
#        [ "Certificate",          20 ],
#        [ "Diploma/Others",       25 ]
#   ]
  
  PROGRAMME_CLASSIFICATION2 = [
       #  Displayed       stored in db
       ["Latihan", 1],
       ["Sesi Pembelajaran (Bersemuka)", 2],
       ["Sesi Pembelajaran (Tidak Bersemuka)", 3],
       ["Pembelajaran Kendiri", 4]
  ]
  
  TRAINING_LEVEL = [
       #  Displayed       stored in db
       [ I18n.t("staff.training.course.domestic"), 1],
       [ I18n.t("staff.training.course.overseas"), 2]
  ]
   
  PROGRAMME_CLASSIFICATION = [
       #  Displayed       stored in db
       [ I18n.t("staff.training.course.training"), 1],
       [ I18n.t("staff.training.course.confront"), 2],
       [ I18n.t("staff.training.course.non_confront"), 3],
       [ I18n.t("staff.training.course.self_training"), 4]
  ]
  
  STAFF_COURSE_TYPE = [
       #  Displayed       stored in db
       [ I18n.t("staff.training.course.course"), 1],
       [ I18n.t("staff.training.course.seminar"), 2],
       [ I18n.t("staff.training.course.convention"), 3],
       [ I18n.t("staff.training.course.workshop"), 4],
       [ I18n.t("staff.training.course.forum"), 5],
       [ I18n.t("staff.training.course.symposium"), 6],
       [ I18n.t("staff.training.course.learning_session"), 7],
       [ I18n.t("staff.training.course.monthly_assembly"), 8],
       [ I18n.t("staff.training.course.special_talk"), 9],
       [ I18n.t("staff.training.course.celebration"), 10],
       [ I18n.t("staff.training.course.presentation"), 11],
       [ I18n.t("staff.training.course.speaker"), 12],
       [ I18n.t("staff.training.course.job_visit"), 13],
       [ I18n.t("staff.training.course.on_job_training"), 14],
       [ I18n.t("staff.training.course.attachment_training"), 15],
       [ I18n.t("staff.training.course.simulation"), 16],
       [ I18n.t("staff.training.course.others"), 17],
       [ I18n.t("staff.training.course.epsa_portal"), 18],  
       [ I18n.t("staff.training.course.e_learning_portal"), 19],  
       [ I18n.t("staff.training.course.hr_knowledge_repo"), 20],  
       [ I18n.t("staff.training.course.book_reading"), 21],  
       [ I18n.t("staff.training.course.jurnal_reading"), 22],  
  ]
  
  DURATION_TYPE = [
       #  Displayed       stored in db
       [ I18n.t("time.hours"), 0],
       [ I18n.t("time.days"),  1 ],
       [ I18n.t("time.months"),2 ],
       [ I18n.t("time.years"), 3 ],
  ]

  PAYMENT=[
    #  Displayed       stored in db
    [I18n.t('staff.training.schedule.local_order'), 1],
    [I18n.t('staff.training.schedule.cash'), 2]
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

  DOCUMENT_CATEGORY = [
          #  Displayed       stored in db
          [ I18n.t("document.letter"),      "1" ],
          [ I18n.t("document.memo"),       "2" ],
          [ I18n.t("document.circular"), "3" ],
          [ I18n.t("document.others"),  "4" ],
          [ I18n.t("document.email"),      "5" ]
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
     
   #Examresults
    SEMESTER = [
              #  Displayed       stored in db
              [ "Tahun 1/Semester I","1" ],
              [ "Tahun 1/Semester II","2" ],
              [ "Tahun 2/Semester I","3" ],
              [ "Tahun 2/Semester II","4" ],
              [ "Tahun 3/Semester I","5" ],
              [ "Tahun 3/Semester II","6" ],

    ]
    #Resultline
    RESULT_STATUS =[
            #  Displayed       stored in db
            [ "Cemerlang", "1"],
            [ "Kepujian", "2"],
            [ "Lulus", "3"],
            [ "Gagal", "4"]
  ]
    
    #Resultline
    RESULT_STATUS_CONTRA =[
            #  Displayed       stored in db
            [ "Lulus", "3"],
            [ "Gagal", "4"]
  ]
    
    #Resultline
    RESULT_REMARK =[
            #  Displayed       stored in db
            [ "Ulang Subjek", "1"],
            [ "VIVA", "2"],
            [ "Tamat Latihan", "3"],
            [ "Naik Semester", "4"],
            [ "Ulang Semester", "5"]
   ]
     
    DAY_CHOICE = [
         #  Displayed       stored in db
         [ "Sun-Wed / Mon-Thurs",  1 ],
         [ "Thurs / Fri",    2 ]
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
            [I18n.t('training.programme.lecture'),     1],
            [I18n.t('training.programme.tutorial'),    2],
            [I18n.t('training.programme.practical'),  3]
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
    
    FINGERPRINT_TYPE = [
      #Displayed       stored in db
      [I18n.t('fingerprint.in'), 1],
      [I18n.t('fingerprint.out'), 2],
      [I18n.t('fingerprint.both'), 3]
    ]
	
    
    # library resources (book)
    
  LOAN = [
        #  Displayed       stored in db 
        [ I18n.t('library.book.open_shelf'), 1],
        [ I18n.t('library.book.red_spot'), 3]
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
   SDCSTATUS = [
         #  Displayed       stored in db
         [ I18n.t('student.discipline.new2'),"New" ],
         [ I18n.t('student.discipline.open'),"Open" ],
         [ I18n.t('student.discipline.no_case'),"No Case" ],
         [ I18n.t('student.discipline.closed'), "Closed" ],
         [ I18n.t('student.discipline.refer_bpl'), "Refer to BPL" ],   
         [ I18n.t('student.discipline.refer_tphep'), "Refer to TPHEP"]
    ]
   
   INFRACTION = [
         #  Displayed       stored in db
         [ I18n.t('student.discipline.smooking'), 1  ],
         [ I18n.t('student.discipline.skip_class'), 2 ],
         [ I18n.t('student.discipline.quarrel'), 3 ],
         [ I18n.t('student.discipline.others'), 4 ]
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
          [ "Negara", "5" ],
          [ "Antarabangsa", "9" ]
   ]
   
  #staff_appraisal_skt
  INDICATORS=[
    [I18n.t('evaluation.skt.quality'), 1],
    [I18n.t('evaluation.skt.time'), 2],
    [I18n.t('evaluation.skt.quantity'), 3],
    [I18n.t('evaluation.skt.cost'), 4]
    ]
  
   
   #staff.training.course
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
             ["Harta Modal",1],
             ["Inventory",2]
  ]
   
  ASSETTYPES = [
             # Displayed        stored in db
             ["H",1],
             ["I",2]
   ]
  
  #TravelClaimReceipt
  RECEIPTTYPE = [
        #  Displayed       stored in db
        [ "Transport",   00 ],
        [ "- Teksi",      11 ],
        [ "- Bas",        12 ],
        [ "- Keretapi",   13 ],
        [ "- Feri",       14 ],
        [ "- Kapal Terbang",15 ],
        [ "---------------",19 ],
        
        [ "Miscellaneous",   40 ],
        [ "-  Tol",        41 ],
        [ "-  Tempat Letak Kereta",42 ],
        [ "-  Dobi",       43 ],
        [ "-  Pos",        44 ],
        [ "-  Telefon/Teleks/Fax",45 ],
        [ "-  Exchanged",   99 ]
  ]
  
  ALLOWANCETYPE = [
        #  Displayed       stored in db
        [ "Elaun Makan",21 ],
        [ "Elaun Makan (S/S)",22 ],
        [ "Elaun Harian",23 ],
        [ "Elaun Lodging",31 ],
        [ "Sewa Hotel",32 ],
        [ "Cukai Kerajaan",33 ]
  ]
  
  LOAN_FILTERS = [
    {:scope => "all",       :label => "All"},
    {:scope => "myloan",    :label => "My Loan"},
    {:scope => "internal",  :label => "Internal"},
    {:scope => "external",  :label => "External"},
    {:scope => "onloan",    :label => "On Loan"},
    {:scope => "pending",   :label => "Pending"},
    {:scope => "rejected",  :label => "Rejected"},
    {:scope => "overdue",   :label => "Due/Overdue"}
  ]
 
 #Student Attendance 
   ABSENT_REASON = [
          #  Displayed       stored in db
          [ "Cuti Sakit","1" ],
          [ "Kecemasan","2" ],
          [ "Biasa", "3" ]
   ]
   
   ABSENT_ACTION = [
          #   Displayed     stored in db
         ["Kaunseling","1"],
         ["Ganti Cuti","2"],
         ["Tunjuk Sebab","3"],
         ["Amaran","4"],
         ["Tatatertib","5"],
         ["Hadir Kelas Gantian","6"]
     ]
  
   #Score  
   #E_TYPES = [
     #  Displayed       stored in db
   #   [ "Clinical Work",1 ],
   #   [ "Assignment",2 ],
   #    [ "Project", 3 ],
   #    [ "Clinical Report", 4 ],
   #    [ "Test", 5 ],
   #    [ "Exam", 6 ],
  #]
   E_TYPES = [
     #Displayed       stored in db
#         ["Select", 0],
        ["Test", 5],
        ["Formative Assessment / Mid Term Exam", 6],
        ["Student-Centered / On-going Assessment", 7],
        ["Affective Assessment", 8],
        ["CA+MSE : Continuous Assessment+Mid Sem Exam", 9],
        ["Other Assessment", 10]
     ]  
   
   #Grade
   GRADE = [
  #  Displayed       stored in db
    [ "80-100% - A",  1 ],
    [ "75-79% - A-",  2 ],
    [ "70-74% - B+",  3 ],
    [ "65-69% - B",   4 ],
    [ "60-64% - B-",  5 ],
    [ "55-59% - C+",  6 ],
    [ "50-54% - C",   7 ],
    [ "45-49% - C-",  8 ],
    [ "40-44% - D+",  9 ],
    [ "35-39% - D",  10 ],
    [ "0-34% - E",     11 ]
  ]

WEIGHTAGE = [
    #  Displayed       stored in db
    [ '5 %',  5],
    [ '10 %', 10],
    [ '15 %', 15],
    [ '20 %', 20],
    [ '25 %', 25],
    [ '30 %', 30],
    [ '35 %', 35],
    [ '40 %', 40],
    [ '45 %', 45],
    [ '50 %', 50],
    [ '55 %', 55],
    [ '60 %', 60],
    [ '65 %', 65],
    [ '70 %', 70],
    [ '75 %', 75],
    [ '80 %', 80],
    [ '85 %', 85],
    [ '90 %', 90],
    [ '95 %', 95],
    [ '100 %', 100]

]

#Kin
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

#Student Leave
   STUDENTLEAVETYPE = [
        #  Displayed       stored in db
        [ I18n.t("student.leaveforstudent.weekend_day"),"Weekend Day" ],
        [ I18n.t("student.leaveforstudent.weekend_overnight"),"Weekend Overnight" ],
        [ I18n.t("student.leaveforstudent.emergency"),"Emergency" ],
        [ I18n.t("student.leaveforstudent.festive_leave"),"Cuti Perayaan" ],
        [ I18n.t("student.leaveforstudent.midterm_break"),"Mid Term Break" ],
        [ I18n.t("student.leaveforstudent.end_of_semester"),"End of Semester" ]
    ]
   STUDENTLEAVETYPE2 = [
        #  Displayed       stored in db
        [ "Hujung Minggu (Siang)", "Weekend Day" ],
        [ "Hujung Minggu (Bermalam)", "Weekend Overnight" ],
        [ "Cuti Kecemasan", "Emergency" ],
        [ "Cuti Perayaan", "Cuti Perayaan" ],
        [ "Cuti Pertengahan Semester", "Mid Term Break" ],
        [ "Cuti Akhir Semester", "End of Semester" ]
    ]
   
end
