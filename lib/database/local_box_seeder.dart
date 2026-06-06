// database/local_box_seeder.dart



import 'package:course_it/models/collage_model.dart';

class LocalBoxSeeder {
  static List<College> seedColleges() {
    return [
      // ─────────────────────────────────────────────────────────────────────
      // College 1: CUSAT
      // ─────────────────────────────────────────────────────────────────────
      College(
        id: 'cusat_kochi',
        name: 'Cochin University of Science and Technology',
        shortName: 'CUSAT',
        city: 'Kochi',
        district: 'Ernakulam',
        type: 'Public/Government',
        affiliation: 'Autonomous University',
        overallRating: 4.5,
        naacGrade: 'A',
        established: 1971,
        amenities: [
          'Gym & Sports Complex',
          'Smart Campus & Free WiFi',
          'Separate Hostels',
          'Central Library',
          'Research Labs',
          'Medical Centre',
        ],
        courses: const [
          Course(
            name: 'B.Tech Computer Science & Engineering',
            stream: 'Engineering',
            annualFee: 75600,
            avgLPA: 7.0,
            maxLPA: 25.0,
            durationYears: 4,
          ),
          Course(
            name: 'B.Tech Electronics & Communication Engineering',
            stream: 'Engineering',
            annualFee: 75600,
            avgLPA: 6.0,
            maxLPA: 18.0,
            durationYears: 4,
          ),
          Course(
            name: 'B.Tech Civil Engineering',
            stream: 'Engineering',
            annualFee: 75600,
            avgLPA: 5.0,
            maxLPA: 14.0,
            durationYears: 4,
          ),
          Course(
            name: 'M.Sc Marine Sciences',
            stream: 'Science',
            annualFee: 62000,
            avgLPA: 5.5,
            maxLPA: 12.0,
            durationYears: 2,
          ),
          Course(
            name: 'MBA',
            stream: 'Management',
            annualFee: 95000,
            avgLPA: 6.5,
            maxLPA: 16.0,
            durationYears: 2,
          ),
        ],
        placementHistory: const [
          PlacementStat(
            year: '2023-24',
            avgLPA: 7.0,
            maxLPA: 25.0,
            medianLPA: 6.5,
            totalPlaced: 312,
            totalStudents: 380,
          ),
          PlacementStat(
            year: '2022-23',
            avgLPA: 6.8,
            maxLPA: 22.0,
            medianLPA: 6.2,
            totalPlaced: 290,
            totalStudents: 365,
          ),
          PlacementStat(
            year: '2021-22',
            avgLPA: 6.2,
            maxLPA: 20.0,
            medianLPA: 5.8,
            totalPlaced: 275,
            totalStudents: 350,
          ),
        ],
        reviews: const [
          Review(
            reviewerName: 'Arun Krishnan',
            batch: 'B.Tech CSE 2023',
            rating: 4.7,
            comment:
                'Excellent research infrastructure. Faculty are highly qualified and industry connections are strong. Campus life is vibrant with multiple technical fests annually. Placements from top MNCs were impressive.',
            isVerified: true,
          ),
          Review(
            reviewerName: 'Meera Nair',
            batch: 'B.Tech ECE 2022',
            rating: 4.4,
            comment:
                'The campus WiFi and smart classroom infrastructure is top-notch for a government university. Hostel facilities are clean and well-maintained. CUSAT truly delivers value for money.',
            isVerified: true,
          ),
          Review(
            reviewerName: 'Vishnu Prasad',
            batch: 'MBA 2024',
            rating: 4.5,
            comment:
                'The MBA program here is underrated. Excellent professors with industry backgrounds and good alumni network. Summer placements were solid with reputed firms visiting campus.',
            isVerified: false,
          ),
        ],
        description:
            'Cochin University of Science and Technology (CUSAT) is a premier public research university in Kochi, Kerala, established in 1971. Situated on the shores of the Vembanad Lake, CUSAT is a NAAC A-accredited institution renowned for its technology, science, and law programs. It consistently ranks among the top technical universities in India and is a preferred destination for aspirants seeking quality education at an affordable government fee structure.',
        imageAsset: 'cusat',
      ),

      // ─────────────────────────────────────────────────────────────────────
      // College 2: Jain University Kochi
      // ─────────────────────────────────────────────────────────────────────
      College(
        id: 'jain_kochi',
        name: 'Jain University – Kochi Campus',
        shortName: 'Jain (Kochi)',
        city: 'Kochi',
        district: 'Ernakulam',
        type: 'Deemed Private',
        affiliation: 'Jain (Deemed-to-be University)',
        overallRating: 4.1,
        naacGrade: 'A+',
        established: 2009,
        amenities: [
          'Gym & Sports Complex',
          'Smart Campus & Free WiFi',
          'Separate Hostels',
          'Innovation Hub',
          'Cafeteria',
          'Career Development Centre',
        ],
        courses: const [
          Course(
            name: 'B.Tech Computer Science',
            stream: 'Engineering',
            annualFee: 300000,
            avgLPA: 5.8,
            maxLPA: 12.0,
            durationYears: 4,
          ),
          Course(
            name: 'BBA – HR Management',
            stream: 'Management',
            annualFee: 350000,
            avgLPA: 4.2,
            maxLPA: 9.0,
            durationYears: 3,
          ),
          Course(
            name: 'B.Sc Forensic Science',
            stream: 'Science',
            annualFee: 240000,
            avgLPA: 4.5,
            maxLPA: 8.5,
            durationYears: 3,
          ),
          Course(
            name: 'B.Com Financial Analytics',
            stream: 'Management',
            annualFee: 200000,
            avgLPA: 4.0,
            maxLPA: 7.5,
            durationYears: 3,
          ),
          Course(
            name: 'B.Sc Data Science',
            stream: 'Science',
            annualFee: 280000,
            avgLPA: 5.2,
            maxLPA: 11.0,
            durationYears: 3,
          ),
        ],
        placementHistory: const [
          PlacementStat(
            year: '2023-24',
            avgLPA: 5.8,
            maxLPA: 12.0,
            medianLPA: 5.2,
            totalPlaced: 186,
            totalStudents: 240,
          ),
          PlacementStat(
            year: '2022-23',
            avgLPA: 5.4,
            maxLPA: 11.5,
            medianLPA: 5.0,
            totalPlaced: 170,
            totalStudents: 228,
          ),
          PlacementStat(
            year: '2021-22',
            avgLPA: 4.9,
            maxLPA: 10.0,
            medianLPA: 4.6,
            totalPlaced: 155,
            totalStudents: 215,
          ),
        ],
        reviews: const [
          Review(
            reviewerName: 'Priya Menon',
            batch: 'B.Tech CSE 2024',
            rating: 4.2,
            comment:
                'Great infrastructure and the innovation hub provides real project exposure. The campus has modern facilities and faculty are approachable. International collaborations add value to the degree.',
            isVerified: true,
          ),
          Review(
            reviewerName: 'Rahul Varma',
            batch: 'BBA 2023',
            rating: 4.0,
            comment:
                'The BBA HR Management program has excellent soft skills training modules. Industry visits are frequent and the career cell is active. Fee is on the higher side but facilities justify it partially.',
            isVerified: true,
          ),
          Review(
            reviewerName: 'Divya Suresh',
            batch: 'B.Sc Forensic Science 2023',
            rating: 4.1,
            comment:
                'Forensic Science labs are well-equipped. Faculty have real investigative experience which makes learning practical. Placement assistance was helpful for government sector roles.',
            isVerified: false,
          ),
        ],
        description:
            'Jain University\'s Kochi Campus is a branch of the NAAC A+ accredited Jain (Deemed-to-be University), headquartered in Bangalore. The Kochi campus provides a modern private university experience with strong focus on skill-based learning, entrepreneurship, and international exposure. Known for diverse course offerings across Engineering, Management, and Sciences, it serves students seeking a premium private institution in the heart of Kerala.',
        imageAsset: 'jain_kochi',
      ),

      // ─────────────────────────────────────────────────────────────────────
      // College 3: GEC Thrissur
      // ─────────────────────────────────────────────────────────────────────
      College(
        id: 'gec_thrissur',
        name: 'Government Engineering College, Thrissur',
        shortName: 'GEC Thrissur',
        city: 'Thrissur',
        district: 'Thrissur',
        type: 'Public/Government',
        affiliation: 'APJ Abdul Kalam Technological University (KTU)',
        overallRating: 4.4,
        naacGrade: 'A',
        established: 1957,
        amenities: [
          'Gym',
          'Separate Hostels',
          'Central Library',
          'Sports Ground',
          'Workshop & Labs',
          'NSS & NCC Units',
        ],
        courses: const [
          Course(
            name: 'B.Tech Mechanical Engineering',
            stream: 'Engineering',
            annualFee: 35000,
            avgLPA: 5.5,
            maxLPA: 18.0,
            durationYears: 4,
          ),
          Course(
            name: 'B.Tech Computer Science & Engineering',
            stream: 'Engineering',
            annualFee: 35000,
            avgLPA: 6.8,
            maxLPA: 20.0,
            durationYears: 4,
          ),
          Course(
            name: 'B.Tech Electrical & Electronics Engineering',
            stream: 'Engineering',
            annualFee: 35000,
            avgLPA: 5.2,
            maxLPA: 15.0,
            durationYears: 4,
          ),
          Course(
            name: 'B.Tech Civil Engineering',
            stream: 'Engineering',
            annualFee: 35000,
            avgLPA: 4.8,
            maxLPA: 12.0,
            durationYears: 4,
          ),
        ],
        placementHistory: const [
          PlacementStat(
            year: '2023-24',
            avgLPA: 6.8,
            maxLPA: 20.0,
            medianLPA: 6.0,
            totalPlaced: 248,
            totalStudents: 300,
          ),
          PlacementStat(
            year: '2022-23',
            avgLPA: 6.1,
            maxLPA: 18.0,
            medianLPA: 5.6,
            totalPlaced: 228,
            totalStudents: 288,
          ),
          PlacementStat(
            year: '2021-22',
            avgLPA: 5.7,
            maxLPA: 16.5,
            medianLPA: 5.2,
            totalPlaced: 210,
            totalStudents: 275,
          ),
        ],
        reviews: const [
          Review(
            reviewerName: 'Sreehari KP',
            batch: 'B.Tech CSE 2024',
            rating: 4.6,
            comment:
                'GEC Thrissur is an absolute gem for government engineering education in Kerala. The legacy and alumni network is phenomenal. Students get ample opportunities through IEEE, CSI and other technical clubs.',
            isVerified: true,
          ),
          Review(
            reviewerName: 'Ananya Raj',
            batch: 'B.Tech Mechanical 2023',
            rating: 4.3,
            comment:
                'The workshop facilities are excellent and practical training is a priority. Campus culture is great with strong NSS involvement. Cost-quality ratio is the best you will find in Kerala.',
            isVerified: true,
          ),
          Review(
            reviewerName: 'Jithin Thomas',
            batch: 'B.Tech EEE 2022',
            rating: 4.2,
            comment:
                'Strong alumni base in core sector companies. GATE coaching support available on campus. The hostel infrastructure could be modernised but overall the academic environment is disciplined and rigorous.',
            isVerified: false,
          ),
        ],
        description:
            'Government Engineering College, Thrissur is one of the oldest and most prestigious engineering institutions in Kerala, established in 1957. Affiliated to APJ Abdul Kalam Technological University, GEC Thrissur is NAAC A-accredited and consistently ranks among the top government engineering colleges in Kerala. Offering exclusively engineering disciplines, it is renowned for producing quality engineers who excel in both core industries and emerging technology sectors.',
        imageAsset: 'gec_thrissur',
      ),

      // ─────────────────────────────────────────────────────────────────────
      // College 4: College of Engineering Trivandrum (CET)
      // ─────────────────────────────────────────────────────────────────────
      College(
        id: 'cet_trivandrum',
        name: 'College of Engineering Trivandrum',
        shortName: 'CET',
        city: 'Thiruvananthapuram',
        district: 'Thiruvananthapuram',
        type: 'Public/Government',
        affiliation: 'APJ Abdul Kalam Technological University (KTU)',
        overallRating: 4.6,
        naacGrade: 'A',
        established: 1939,
        amenities: [
          'Gym & Sports Complex',
          'Separate Hostels',
          'Central Library',
          'Smart Classrooms',
          'Research Centre',
          'Medical Centre',
          'Auditorium',
        ],
        courses: const [
          Course(
            name: 'B.Tech Computer Science & Engineering',
            stream: 'Engineering',
            annualFee: 35000,
            avgLPA: 8.2,
            maxLPA: 32.0,
            durationYears: 4,
          ),
          Course(
            name: 'B.Tech Electronics & Communication Engineering',
            stream: 'Engineering',
            annualFee: 35000,
            avgLPA: 7.1,
            maxLPA: 22.0,
            durationYears: 4,
          ),
          Course(
            name: 'B.Tech Mechanical Engineering',
            stream: 'Engineering',
            annualFee: 35000,
            avgLPA: 5.8,
            maxLPA: 16.0,
            durationYears: 4,
          ),
          Course(
            name: 'B.Tech Architecture',
            stream: 'Engineering',
            annualFee: 35000,
            avgLPA: 5.5,
            maxLPA: 14.0,
            durationYears: 5,
          ),
        ],
        placementHistory: const [
          PlacementStat(
            year: '2023-24',
            avgLPA: 8.2,
            maxLPA: 32.0,
            medianLPA: 7.5,
            totalPlaced: 290,
            totalStudents: 340,
          ),
          PlacementStat(
            year: '2022-23',
            avgLPA: 7.8,
            maxLPA: 28.0,
            medianLPA: 7.0,
            totalPlaced: 272,
            totalStudents: 325,
          ),
          PlacementStat(
            year: '2021-22',
            avgLPA: 7.2,
            maxLPA: 25.0,
            medianLPA: 6.6,
            totalPlaced: 255,
            totalStudents: 310,
          ),
        ],
        reviews: const [
          Review(
            reviewerName: 'Arjun Pillai',
            batch: 'B.Tech CSE 2024',
            rating: 4.8,
            comment:
                'CET is arguably the best government engineering college in Kerala. The placement record in CSE is outstanding with multiple students getting 20+ LPA packages from top product companies.',
            isVerified: true,
          ),
          Review(
            reviewerName: 'Lakshmi Devi',
            batch: 'B.Tech ECE 2023',
            rating: 4.5,
            comment:
                'Incredible alumni network. College culture promotes both academics and extracurriculars brilliantly. Faculty are experienced and guide students well for higher studies abroad.',
            isVerified: true,
          ),
        ],
        description:
            'College of Engineering Trivandrum (CET) is the oldest engineering college in Kerala, established in 1939. It is one of the most coveted institutions in the state, consistently featuring in the top engineering colleges list nationally. With a legacy spanning over 8 decades, CET boasts a distinguished alumni network across leading global technology companies and research institutions.',
        imageAsset: 'cet',
      ),

      // ─────────────────────────────────────────────────────────────────────
      // College 5: Kerala Law Academy Law College (for diversity)
      // ─────────────────────────────────────────────────────────────────────
      College(
        id: 'rajagiri_kochi',
        name: 'Rajagiri College of Social Sciences',
        shortName: 'Rajagiri',
        city: 'Kochi',
        district: 'Ernakulam',
        type: 'Deemed Private',
        affiliation: 'Mahatma Gandhi University',
        overallRating: 4.3,
        naacGrade: 'A',
        established: 1955,
        amenities: [
          'Gym & Sports Complex',
          'Smart Campus & Free WiFi',
          'Separate Hostels',
          'Chapel & Meditation Centre',
          'Cafeteria',
          'Placement Cell',
        ],
        courses: const [
          Course(
            name: 'MBA – Marketing & Finance',
            stream: 'Management',
            annualFee: 220000,
            avgLPA: 6.2,
            maxLPA: 14.0,
            durationYears: 2,
          ),
          Course(
            name: 'BBA',
            stream: 'Management',
            annualFee: 95000,
            avgLPA: 4.5,
            maxLPA: 9.0,
            durationYears: 3,
          ),
          Course(
            name: 'MSW – Social Work',
            stream: 'Arts',
            annualFee: 80000,
            avgLPA: 4.0,
            maxLPA: 7.5,
            durationYears: 2,
          ),
          Course(
            name: 'B.Sc Psychology',
            stream: 'Science',
            annualFee: 65000,
            avgLPA: 3.8,
            maxLPA: 7.0,
            durationYears: 3,
          ),
        ],
        placementHistory: const [
          PlacementStat(
            year: '2023-24',
            avgLPA: 6.2,
            maxLPA: 14.0,
            medianLPA: 5.5,
            totalPlaced: 195,
            totalStudents: 240,
          ),
          PlacementStat(
            year: '2022-23',
            avgLPA: 5.9,
            maxLPA: 13.0,
            medianLPA: 5.2,
            totalPlaced: 180,
            totalStudents: 226,
          ),
          PlacementStat(
            year: '2021-22',
            avgLPA: 5.4,
            maxLPA: 11.5,
            medianLPA: 4.9,
            totalPlaced: 162,
            totalStudents: 210,
          ),
        ],
        reviews: const [
          Review(
            reviewerName: 'Nisha George',
            batch: 'MBA 2024',
            rating: 4.4,
            comment:
                'Rajagiri has a wonderful blend of value-based education and professional training. The MBA program has excellent industry interface and faculty with strong corporate backgrounds. Campus life is warm and community-driven.',
            isVerified: true,
          ),
          Review(
            reviewerName: 'Kevin James',
            batch: 'BBA 2023',
            rating: 4.2,
            comment:
                'Great college with a distinct culture. The placements for BBA students cover reputed companies. The management studies department is exceptionally well-run with real-world project integrations.',
            isVerified: true,
          ),
        ],
        description:
            'Rajagiri College of Social Sciences, Kochi is a NAAC A-accredited institution run by the CMI Fathers, established in 1955. It is a leading institution in Kerala for Management, Social Sciences, and Psychology. The college is known for its ethical leadership approach to education, blending professional training with social responsibility, and maintains strong corporate relationships for student placements.',
        imageAsset: 'rajagiri',
      ),
    ];
  }
}
