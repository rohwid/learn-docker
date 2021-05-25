# Tentang Docker

Digunakan untuk deploy aplikasi ke server dengan melakukan bundling seluruh dependency yang dibutuhkan oleh aplikasi tersebut. Docker adalah container manager bukan virtual machine, sedanggkan pada VM biasanya disebut dengan VM manager. Dalam VM biasanya berisi OS, App dependency, dan Aplikasinya, sedangan pada Docker atau Container Manager tidak memiliki OS. Nah lantas dari mana OS yang akan digunakan oleh Container Manager, OS yang digunakan diperoleh dari OS induk dari Container Manager yang dibuat dengan cara isolate, sehingga tidak akan merusak OS induk.

## Installasi Docker

Ikuti langkah-langkah installasi sesuai dengan dokumentasi, kemudian lanjutkan dengan pengecekan pada Terminal menggunakan perintah:

    $ docker info

Apakah sudah dapat menampilkan info dari docker, bisa juga dengan perintah berikut untuk melakukan pengecekan server:

    $ docker --version

## Docker Architecture

Saat installasi docker dilakukan, sebenarnya terjadi installasi dua buah aplikasi docker, yaitu `docker client` dan `docker server` atau `DOCKER_HOST`. Pada dasarnya yang akan lebih banyak digunakan adalah `docker client` pada laptop sedangkan `docker server` mungkin akan lebih banyak dipakai pada di server atau production environment. Di karenakan oleh proses development maka perlu dilakukan installasi `docker client` dan `docker server` pada laptop developer.

+ `Docker client` biasanya berfungsi melakukan perintah ke `docker server`.
+ Sedangakan `docker server` berfungsi memanage container atau bertindak sebagai container manager. Lebih detailnya dia akan melakukan management `image`, `container`, dan juga terhubung dengan `registry`.

Berikut adalah ilustrasi dari Docker Architecture:

![alt text](img/docker-architecture.png)

## Docker Registry atau Container Registry

`Container registry` adalah tempat untuk menyimpan image docker, jadi *image ini dibuat untuk membundle aplikasi sebelum dilakukan deploy ke `docker server`*. Jadi hal ini bertujuan untuk pemakaian yang berkelanjutan, dimana setiap image dapat dipakai berulang ke setiap node. Maka setiap image disimpan dalam `registry` dan setiap server yang membutuhkan tinggal mengambil saja ke dalam `registry`. Selain itu docker registri juga berfungsi untuk sharing image antar developer.

+ [Docker Hub](https://hub.docker.com/)
+ [Google Container Registry](https://cloud.google.com/container-registry)
+ [Amazon Elastic Container Registry](https://aws.amazon.com/ecr/)

## Image

Seperti yang sudah dibahas sebelumnya image adalah *bundle dari aplikasi yang siap dijalankan tanpa perlu di install*, tidak seperti installer atau ISO images. Pada docker image sendiri terdapat istilah `tags` yang dapat diasumsikan sebagai versi dari aplikasi yang dibundle tersebut. Misalkan terdapat docker image dari Python dengan versi 3.6, tetapi dalam docker registry yang dicontohkan oleh Docker Hub terdapat berbagai versi seperti python for windows server bahkan sampai dengan python versi 2.0. Kemudian dalam `docker server` juga dapat dilakukan deployment docker image untuk satu aplikasi namun dengan berbagai macam `tags`.

## Container

Definisi dari `container` sendiri adalah image yang sebelumnya terdapat pada `docker registry` itu dijalankan atau running pada `docker server`, bisa disebut juga dengan instasiasi image. Selanjutnya jumlah dan jenis image yang dijalankan selanjutnya disebut dengan container tersebut, tidak hanya berjumlah 1 tapi dapat berjumlah banyak dan dengan jenis yang sama.

# Penggunaan Docker

Berikut adalah contoh langkah-langkah dalam penggunaan docker.

## Ambil Images dari Registry

Melihat list image yang kita miliki dengan perintah berikut:

    $ docker images

Kemudian buka `Docker hub` dan cari images yang ingin di download, misalkan contoh pada perintah berikut adalah mongodb:

    $ docker pull mongo

Dengan perintah tersebut maka versi atau tags yang d gunakan secara default adalah `lates`. Jika kita ingin mendownload versi yang lain (contoh: v4.4.4), maka dapat menggunakan perintah berikut:

    $ docker pull mongo:4.4.4

## Membuat Container

Menampilkan seluruh container yang sedang berjalan dapat dengan menggunakanan perintah berikut:

    $ docker container ls

Sedangkan untuk melihat seluruh container, bahkan yang sedang tidak berjalan maka gunakan perintah berikut:

    $ docker container ls --all

Gunakan perintah berikut untuk membuat container:

    $ docker container create mongo:4.1

Namun perintah tersebut akan membuat random name untuk container. Maka dari itu gunakan perintah berikut dengan tambahkkan opsi `--name`:

    $ docker container create --name mongoserver1 mongo:4.4.4

**Note:** Nama disini bersifat unik dan tidak bisa disamakan.

## Menjalankkan Container

Untuk menjalanlan container dapat menggunakan perintah berikut, dicontohkkan dengan nama container yang sebelumnya dibuat:

    $ docker container start mongoserver1

Kemudian gunakan perintah sebelumnya untuk melihat apakah container tersebut sudah berjalan:

    $ docker container ls

Kemudian coba akses mongodb tersebut (dapat mengguunakan Studi 3T atau cara yang lain) pada alamat `localhost:27017`. Tetapi hal ini gagal dilakukkan karena pada dasarnya port yang diekspose oleh mongoDB tersebut adalah port pada tingkat containernya saja. **Jadi pastikan saat menjalankan container lakukan juga expose port pada container yang ingin dijalankan**.

## Menghapus Container

Kemudian terdapat cara untuk menghapus container dengan perintah:

    $ docker container rm mongoserver1

Namun hal ini masih belum dapat dilakukan dikarenakan container tersebut masuh berjalan, maka stop dulu container yang sedang berjalan dengan perintah berikut:

    $ docker container stop mongoserver1

Dapat juga melakukan stop untuk dua container sekaligus dengan perintah berikut:

    $ docker container stop mongoserver1 mongoserver2

Kemudian baru lakukan penghapusan terhadap dua container tersebut:

    $ docker container rm mongoserver1 mongoserver2

## Membuka atau Expose Port untuk Container

Gunakan perintah berikut untuk membuat container sekaligus melakukan expose pada port tersebut:

    $ docker container create --name mongoserver1 -p 8080:27017 mongo:4.4.4

Yang mana port `8080` adalah port eksternal yang diekspose, dan `27017` adalah port lokal atau container dari mongodb. Kemudian jika ingin menambahkan 1 container mongodb lagi maka dapat menjalankan perintah berikut:

    $ docker container create --name mongoserver2 -p 8181:27017 mongo:4.4.4

Perlu diingat bahwa port `8080` dan `8181` adalah port dari komputer induk atau server sedangkan `27017` adalah port lokal dari container yang menjalankan mongodb.

## Menghapus Docker Images

Gunakan perintah berikut untuk melihat daftar images:

    $ docker images

Selanjutnya hapus images yang ingin dipilih dengan perintah berikut:

    $ docker image rm <image ID>

Atau

    $ docker image rm <repository>:<tag>

Contoh

    $ docker image rm bbfd3e575f12

Atau

    $ docker image rm mongo:4.4.4

Tetapi kemudian muncul error yang menyatakan bahwa image tersebut tidak dapat dihapus selama masih digunakan oleh container, seperti pesan berikut:

    Error response from daemon: conflict: unable to remove repository reference "mongo:4.4.4" (must force) - container 1f4129490fe3 is using its referenced image bbfd3e575f12

Maka dari itu container yang dibuat sebelumnya harus dihapus terlebih dahulu, hal ini dapat diasumsikan bahwa image adalah bukan installer yang dapat dihapus saat selesai installasi. Jadi dapat disimpulkan lagi, bahwa container adalah running images.

Kemudian lanjutkan dengan stop container:

    $ docker container stop mongoserver1 mongoserver2

Lalu hapus container:

    $ docker container rm mongoserver1 mongoserver2

Barulah penghapusan images dapat dilakukan:

    $ docker imager rm mongo:4.4.4

## Membuat Image dengan Docker File

Pada awalnya siapkan sebuah project yang nantinya akan digunakan untuk proses deployment, misal ini adalah project ini dicontohkan pemakaian Nodejs dalam file `server.js` untuk program utama, `package.json` dan `package-lock.json` untuk konfigurasi *dependency* dari program tersebut. Dalam pembuatan image docker menggunakan `Dockerfile` ini tidak dibuat dari awal, melainkan menggunakan image yang sudah ada di [Docker Hub](https://hub.docker.com/). Hasil untuk script Dockerfile yang baru saja dibuat hasilnya terdapat pada file `Dockerfile`. Jika sudah selesai maka lakukan eksekusi pembuatan docker image menggunakan `Dockerfile` dengan perintah berikut:

    $ docker build --tag <image-name>:<tag> .

Contohnya

    $ docker build --tag app-node:1.0 .

Kemudian lakukan pengecekkan apakah aplikasi tersebut sudah ada dalam list image:

    $ docker images

Lanjutkan dengan pembuatan container. Pada kasus ini terdapat dua cara, yaitu:

### 1. Buat Container Terlebih Dahulu dan Jalankan Container Tersebut

Buat container dengan menggunakan perintah berikut:

    $ docker container create --name app1 --publish 3000:3000 app-node:1.0

Kemudian cek dengan perintah:

    $ docker container ls --all

Selanjutnya jalankan container tersebut dengan perintah berikut:

    $ docker container start app1

Lanjutkan dengan pengecekan pada browser di alamat `http://localhost:3000`.

### 2. Buat Container dan Langsung Jalankan Container Tersebut

Buat container sekaligus jalankan container tersebut dengan menggunakan perintah berikut:

    $ docker run --name app1 --publish 3000:3000 app-node:1.0

Maka akan muncul pemberitahuan kalau aplikasi atau `app1` yang sudah dideploy sudah berjalan. Selanjutnya dapat dilakukan pengecekan pada browser di alamat `http://localhost:3000`. Kemudian jika aplikasi tersebut dihentikan dengan menekan tombol `CTRL + C` misal, maka aplikasi tersebut akan berhenti dan otomatis sudah muncul pada list docker container dengan perintah berikut:

    $ docker container ls --all

Kemudian dengan penambahan flag `detach` maka aplikasi akan langsung berjalan sebagai container tanpa perlu melakukan perintah `start` terhadap container yang baru saja dibuat:

    $ docker run --name app1 --publish 8080:8080 --detach app-node:1.0

Maka aplikasi `app1` yang sudah dideploy sudah berjalan sebagai container karena penggunaan flag `--detach`. Selanjutnya dapat dilakukan pengecekan pada browser di alamat `http://localhost:8080` dan pengecekan dengan perintah:

    $ docker container ls --all

### 3. Penambahan Flag `--rm`

Dengan adanya penambahan flag `--rm` maka setelah container tersebut berjalan lalu kemudian di hentikan dengan perintah `docker container stop` atau jika komputer induk mati yang mengakibatkan service docker berhenti. Maka container yang baru saja dibuat akan langsung terhapus secara otomatis. Berikut adalah contoh pembuatan container dengan flag `--rm`:

    $ docker run --name app1 --rm --publish 8080:8080 --detach app-node:1.0

## Upload Image ke Registry

Pada website [Docker Hub](https://hub.docker.com/) kemudian pilih `Create Repository`, maka kemudian akan muncul sebuah perintah untuk melakukan push images ke [Docker Hub](https://hub.docker.com/) sebagai berikut:

    $ docker push new-repo/image-name:tagname

Contohnya

    $ docker push rohwid/app-node:1.0

Tetapi image yang dibuat hanya bernama `app-node` dengan tag `1.0` atau `app-node:1.0`, maka dari itu perlu dilakukan konversi dengan menggunakan perintah berikut:

    $ docker tag local-image:tagname new-repo:tagname
    
    $ docker push new-repo:tagname

Contohnya

    $ docker tag app-node:1.0 rohwid/app-node:1.0

    $ docker push rohwid/app-node:1.0

Jika proses push gagal maka penyebabnya biasanya adalah dikarenakan docker mengharuskan penggunanya untuk login dengan perintah berikut:

    $ docker login

##  Environment Variable pada Docker

Konfigurasi yang baik itu adalah konfigursi yang bisa diset dari luar bundle atau docker images, misal seperti `username` dan `password` yang selalu berubah-ubah. Dalam mengatasi hal tersebut maka jangan melakukan hardcode didalam apllikasinya, melainkan **lakukan export kedalam environment variable**. Selanjutnya kita coba membuat docker image yang support enviroment variable. Berikut adalah environment variable yang akan digunakan:

    USERNAME=${UNAME}

Penambahan environment variable dapat dilakukan dengan menambahkan `flag` saat pembuatan container seperti perintah berikut ini.

    $ docker container create --name app-node --publish 8080:8080 --env USERNAME=docker app-node:1.0

Kemudian untuk melihat apakah environement pada container tersebut sudah berhasi terpasang, maka dapat dilakukan pengecekan dengan perintah berikut pada bagain `Environment`:

    $ docker container inspect app-node

Selanjutnya jika ingin menambah jumlah environment, maka cukup hanya dengan melakukan penambahan perintah, sebagaimana perintah berikut:

    $ docker container create --name app-node --publish 8080:8080 --env USERNAME=docker --env DIR=/home/rohwid/app-node app-node:1.0

## Integrasi Container dengan Network

Dalam kasus ini diambil contoh saat implementasi database `MongoDB` dan `Redist`. Tentuunya hal tersebut memmerlukan Environment juuga untuk menjalankan databaset, maka secara otomatis jumlah Container dari docker yang akan digunakan berjumlah 3 yaitu MongoDB, Redis, dan Image dari Container itu sendiri.

Setup Network yang akan menghubungkan setiap Container, hal ini diperlukan karena dari setiap container tersebut pada dasarnya adalah berdiri secara stand-alone dan tidak berkomunikasi satu dengan yang lain:

    $ docker network create app-net

Pertama buat container untuk masing-masing database dan aplikasi yang ingin dijalankan.

+ MongoDB (Image ambil dari docker hub):

    $ docker container create --name mongo --publish 27017:27017 mongo:4-xenial

+ Redis (Image ambil dari docker hub):

    $ docker container create --name redis --publish 6379:6379 redis:5

+ Aplikasi utama (Tambahkan juga environment variable untuk):

    $ docker container create --name app-node --publish 8080:8080 --env NAME=docker --env MONGO_HOST=mongo --env MONGO_PORT=27017 --env REDIS_HOST=redis --env REDIS_PORT=6379 app-node:1.0

Kemudian langkah selanjutnya adalah masukan setiap container tersebut ke dalam Docker Network yang sebelumnya dibuat.

    $ docker network connect app-net mongo
    $ docker network connect app-net appredis
    $ docker network connect app-net app-node

Selanjutnya lakukan pengecekan pada setiap container yang dibuat, apakah sudah masuk ke dalam Docker Network dengan perintah berikut pada bagian `Networks`:

    $ docker container inspect app-node

Jika diperlukan restart, maka lakukan restart agar setiap container yang sebelumnya dibuat dapat terhubung kembali.

## Integrasi Banyak Container dengan Docker Compose

Dalam melakukan konfigurasi perlu melakukan konfigurasi dalam file `*.yaml`. Kemudian urutan eksekusi dari file konfiguras dalam format `*.yaml` tersebut dieksekusi dari atas ke bawah. Dalam file biasanya dimuat konfigurasi dari setiap image dan container yang akan dijalankan, environent variable, networks, dan lain sebagainya.

Kemudian dalam file `*.yaml` tersebut terdapat banyak attribut seperti `container_name`, `image`, `ports` dan lain-lain. Atribut-atribut tersebut biasa digunakan pada perinntah saat pengoperasian image atau container, namun pada bagian ini akan dijelaskan attribut yang tidak biasa digunakan dalam pengoperasian container atau images. Misalnya

+ `depens_on`: Urutan container mana yang harus dieksekusi terlebih dahulu sebelum container lain atau container utama.
+ `environment`: Enviroment variable yang akan diterapkan pada sistem operasi yang dijalankan oleh docker container. 

Selanjutnya gunakan perintah berikut untuk menjalankan script dan deploy seluruh container beserta konfigursinya yang terdapat dalam file `*.yaml` tersebut.

    $ docker-compose up

Jika ingin menjalankannya dalam backgroud maka dapat ditambah dengan flag `--detach`.

    $ docker-compose up --detach

Jika ingin menghentikan container tersebut maka dapat menggunakan perintah:

    $ docker-compose stop

Dan untuk menjalankannya kembali dengan perintah:

    $ docker-compose start

Sedangkan untuk menghentikan dan menghapus seluruh container beserta isinya, dapat dengan perintah berikut.

    $ docker-compose down

## Manage Data dengan Docker

Pada pembuatan aplikasi diusahakan semuanya dapat berjalan secara **stateless** atau tidak memerlukan penyimpanan data saat aplikasi berjalan atau **statefull**, namun lain halnya dengan database yang tentunya memerlukan penyimpanan. Dalam kasus ini dalam proses manage data terdapat beberapa fitur yang dapat digunakan diantaranya adalah `Volume` yang membuat docker memiliki penyimpanan sendiri dan dapat melakukan fitur sepert `Backup`, `Restore`, atau `Migrate`. Selanjutnya terdapat fitur `Bind mounts` yang dapat menghubungkan antara directory local pada komputer induk atau `host` dengan directory pada container, maka hal tersebut memungkinkan saat dihapusnya container maka file atau data dalam folder pada komputer induk tidak akan hilang. Berikut adalah langkah pembuatan `volume`:

Lakukan pembuatan `volume` dengan perintah (dengan kasus mongoDB):

    $ docker volume create mongo_data

Kemudian lanjutkan dengan pembuatan container dan hubungkan dengan `volume`:

    $ docker container create --name mongodb --volume mongo_data:/data/db --publish 5432:5432 mongo:4-xenial

Directory `/data/db` tersebut adalah tempat data base dari mongoDB disimpan. Saat container itu dihapus, maka data akan tertap tersimpan dalam `volume`. 

    $ docker container rm mongodb

Saat dilakukan pembuatan ulang container dengan menggunakan `volume` yang sama, maka secara otomatis data tersebut dapat diakses dari container baru tersebut.  

    $ docker container create --name mongodb --volume mongo_data:/data/db --publish 5432:5432 mongo:4-xenial

Sedangkan untuk `Bind mount` hanya cukup dengan mengganti `volume` dengan `local directory`.

    $ docker container create --name mongodb --volume /home/ubuntu/mongo_data:/data/db --publish 5432:5432 mongo:4-xenial

## Pengaksesan TTY pada Container

Dalam pengaksesan terminal session atau TTY dapat dilakukan secara langsung setelah container dibuat, pada contoh ini digunakan image dari `python:3.8-slim-buster`:

    $ docker run --name app2 --interactive --tty --publish 8080:8080 python:3.8-slim-buster

Contohnya:

    $ docker run --name app2 --interactive --tty --publish 8080:8080 python:3.8-slim-buster

Maka setelah container tersebut berhasil dibuat, akan langsung masuk menuju ke dalam terminal session atau TTY dari container tersebut. Sedangkan untuk keluar dari session atau TTY dari container tersebut maka cukup dengan menggunakan perintah `exit`. Setelah keluar dari session tersebut container akan terus berjalan, dan untuk mengaksesnya kembali dapat digunakan perintah berikut:

    $ docker exec --interactive --tty <container name atau id> /bin/bash

Contohnya:

    $ docker exec --interactive --tty python-3.8-env /bin/bash

## Membersihkan Sampah

Dalam membersihkan Image, Network, Volume dan Container yang tidak berjalan dapat dengan menggunakan perintah `prune`.

Misalkan dalam Image dengan menggunakan perintah berikut, maka yang dihapus adalah image yang bersifat `dangling` saja.

    $ docker image prune

Sedangkan untuk mengahapus semua image yang tidak terpakai oleh container yang berjalan maka dapat menggunakan perintah berikut:

    $ docker image prune --all

Hal ini juga berlaku untuk Network, Volume dan Container sebagaimana perintah berikut:

    $ docker network prune

    $ docker volume prune

    $ docker container prune

