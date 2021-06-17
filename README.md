1. Google maps
2. Firebase Login
3. Firebase Firestore


Haritaya aynı anda 1000 veri yüklenmeye çalıştığında telefonda kasma oluşuyor.
Bu durumun önüne geçmek için bir kaç yöntem izlenebilir.
1. Yöntem
- Lazy olarak verileri sunucudan alıp harita üzerinde göstermek.
2. Yöntem 
- Cluster kullanarak aynı anda 1000 tane marker çizdirmek yerine, cluster kullanmak.
3. Yöntem
- 1000 marker göstermek yerine haritaya yaklaştıkça markerları gösterebiliriz. Üst zoom seviyesinde kasma olmayacak şekilde sayı belirlenip. Zoom arttıkça alana(bbox) düşen veri sayısı azalacağı için tamamını göstermekde sorun yaşanmayabilir.
  
