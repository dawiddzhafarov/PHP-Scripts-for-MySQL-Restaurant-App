-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Czas generowania: 25 Sty 2022, 18:38
-- Wersja serwera: 8.0.26
-- Wersja PHP: 8.0.15

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Baza danych: `s402639`
--

DELIMITER $$
--
-- Funkcje
--
CREATE DEFINER=`s402639`@`localhost` FUNCTION `update_status_fun` () RETURNS TINYINT(1) BEGIN
DECLARE n INT;
DECLARE i INT DEFAULT 0;
DECLARE id INT;
DECLARE time_val DATETIME;
SELECT COUNT(*) FROM orders INTO n;
SET i = 0;
WHILE (i < n) DO
	SELECT time into time_val FROM orders LIMIT i,1;
    SELECT order_id into id FROM orders  LIMIT i,1;
    IF((SELECT TIMESTAMPDIFF(MINUTE, time_val, NOW()) >= 5) AND (SELECT TIMESTAMPDIFF(MINUTE, time_val, NOW()) < 20)) 		THEN
    	UPDATE orders SET status = 'w przygotowaniu' WHERE order_id = id;
    ELSEIF(SELECT TIMESTAMPDIFF(MINUTE, time_val, NOW()) >= 20 AND (SELECT TIMESTAMPDIFF(MINUTE, time_val, NOW()) <= 30)) 
    THEN
    	UPDATE orders SET status = 'w trakcie dostawy' WHERE order_id = id;
    ELSEIF(SELECT TIMESTAMPDIFF(MINUTE, time_val, NOW()) >= 30) 
    THEN
    	UPDATE orders SET status = 'dostarczone' WHERE order_id = id;
    END IF;
    SET i = i +1;
    END WHILE;
    RETURN TRUE;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `menu`
--

CREATE TABLE `menu` (
  `food_id` int NOT NULL,
  `name` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `price` float DEFAULT NULL,
  `ingredients` text COLLATE utf8mb4_unicode_ci,
  `description` text COLLATE utf8mb4_unicode_ci,
  `category` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Zrzut danych tabeli `menu`
--

INSERT INTO `menu` (`food_id`, `name`, `price`, `ingredients`, `description`, `category`) VALUES
(1, 'Stripsy', 9.9, 'kurczak, bu??ka tarta, p??atki kukurydziane jajko, mieszanka przypraw', 'Pyszne kawa??ki kurczaka w z??ocistej panierce. S?? tak chrupi??ce, ??e s??siedzi b??d?? pyta??, kto robi remont w mieszkaniu. Idealny smak zapewnia im odpowiednia mieszanka przypraw oraz tajemniczy sk??adnik - mi??o????, z jak?? przygotowujemy wszystkie nasze dania. Przyst??pne cenowo, \r\nzapewni?? ka??demu ??asuchowi szybk?? przegryzk??!', 'fast'),
(2, 'Burrito', 12.9, 'stripsy z kurczaka, sa??ata, cebula, papryka, ser cheddar, majonez, ketchup', 'Czy zat??skni??e?? za czasem sp??dzonym w ??onie matki, kiedy otulony mi??o??ci?? i ciep??em mog??e?? sobie le??e?? i nic nie robi??? W??a??nie tak czuje si?? wn??trze naszego burrito! Wype??nione po brzegi dodatkami sprawi, ??e powr??cisz my??lami do tamtych czas??w. Uwaga - ??adne sk??adniki nie wypadaj?? z wn??trza naszej przek??ski, aby?? m??g?? cieszy?? si?? higienicznym spo??ywaniem posi??ku!', 'fast'),
(3, 'Burger', 25.9, 'bu??ka, sezam, mi??so mielone wo??owe, boczek, ser cheddar, grillowany ser, ketchup, pikle, cebula, pomidor, sa??ata, tajemniczy sos', 'Masz ochot?? na co?? wielkiego i pe??nego smaku? Wst??p po naszego burgera! To a?? 13 warstw rozkoszy dla podniebienia i mn??stwo kalorii, kt??re zaspokoj?? nawet najwi??kszy g????d. Kanapka jest zawsze ??wie??a i ciep??a, tak wysoka, ??e ??adna ilo???? botoksu nie pozwoli ci jej zmie??ci?? na raz w ustach. Symfoni?? smak??w dope??nia tajemny sos, kt??rego receptura zosta??a opracowana przez nas, dla was.', 'kanapka'),
(4, 'Chicken Burger', 22.9, 'bu??ka, sezam, sa??ata, stripsy z kurczaka, ser cheddar, pra??ona cebulka, tajemniczy sos', 'Z jakiego?? powodu martwisz si?? o ??ycie kr??wek? Spokojnie, mamy co?? dla ciebie! Chicken burger to kanapka wype??niona wielkim kotletem z kurczaka, co czyni j?? l??ejsz?? od tradycyjnego burgera. Nie ma w sobie tylu warstw, pozosta?? w niej jednak wyj??tkowy smak, kt??ry nadaje jej nasz tajemniczy sos. Burger jest te?? szczeg??lnie chrupi??cy za spraw?? pra??onej cebulki.', 'kanapka'),
(5, 'Sandwich', 16.9, 'szynka, ser ??????ty, pomidor, sa??ata, musztarda, mi??d, bu??ka', 'Brakuje ci czas??w, kiedy mama pakowa??a ci kanapki do szko??y? ??aden problem! Nasz sandwich sprawi, ??e poczujesz si?? jak w 7 klasie, kiedy wymienia??e?? kanapk?? z pasztetem na tak?? z d??emem. Z tym ??e u nas nie ma d??emu. S?? za to pe??nowarto??ciowe warzywa, plastry szynki oraz przepyszny sos miodowo-musztardowy. A to wszystko otulone grillowan?? bu??k??. I co, nadal chcesz si?? zamieni???', 'kanapka'),
(6, 'Kurczak', 50, 'kurczak, ziemniaki, mieszanka przypraw, czosnek, mi??d, musztarda', 'Danie dla najwi??kszego g??odomora. To zwyczajnie ca??y kurczak upieczony na ro??nie, aby swoim soczystym mi??skiem ??askota?? kubki smakowe naszych klient??w. Jego z??ocista sk??rka uzyskana za pomoc?? kilkunastogodzinnego marynowania to efekt naszych prac nad receptur??, kt??ra zadowoli nawet najbardziej wybrednych klient??w. Przyrz??dzany z czosnkiem, podawany z pieczonymi ziemniakami.', 'danie'),
(7, 'Ryba', 40.8, 'ryba, ry??, groszek, marchew, papryka, kapusta, awokado, limonka, mieszanka przypraw', 'Jeste?? fanem dar??w morza? Zapraszamy na nasz?? rybk??! Jej ostatnim ??yczeniem by??o, ??eby taki smakosz jak ty m??g?? si?? ni?? posili??! Wielki okaz od lokalnego dostawcy, idealnie przyrz??dzony na grilu i doprawiony. Smaku dodaje limonka, kt??r?? nale??y skropi?? ryb?? przez spo??yciem. Podawana z ry??em i sa??atk?? z awokado, papryki i kapusty. ', 'danie'),
(8, 'Szasz??yki', 32.8, 'jagni??cina, czosnek, og??rek kiszony, pomidor, mieszanka przypraw', 'Masz obsesj?? na punkcie uk??adania r??wno przedmiot??w? Szasz??yk to idealna kompozycja dla ciebie! Przyrz??dzony z mi??sa jagni??cego sk??ada si?? z naprzemiennej kombinacji: mi??so, czosnek, og??rek, pomidor. Mi??so, czosnek... i tak dalej. Dopilnujemy, ??eby kucharz nie pomyli?? si?? w tej kolejno??ci.', 'danie'),
(9, 'Kebab', 30.8, 'mi??so wo??owe, ziemniaki, cebula czerwona, sa??ata, kapusta czerwona og??rek kiszony, pomidor, majonez, czosnek, chili, mieszanka przypraw', 'Czym by by??a knajpa bez kebabu? U nas podawany jest on w bogatej wersji, bez ??adnego owijania w... tortill??. Wszystko le??y na talerzu i czeka, a?? kto?? si?? tym zajmie. Tradycyjnie, smaku doda nasz tradycyjny, polski og??rek kiszony, a pikanterii nasz autorski sos czosnkowo-majonezowo-paprykowy. Ogniste wra??enia murowane! Podawany z frytkami, sosem i sa??atk??.', 'danie'),
(10, 'Spaghetti', 24.9, 'makaron, mi??so wieprzowe, pomidory, parmezan, mieszanka przypraw', 'Powiew Italii w naszej restauracji! To klasyczny, znany wszystkim makaron z sosem pomidorowym. Kucharz nie ??ama?? jak gotowa??. Pot????na porcja d??ugiego makaronu z wolnogotowanym sosem i idealnie doprawionym mi??sem. A to wszystko pod pierzynk?? z prawdziwego parmezanu. Mamma mia!', 'makaron'),
(11, 'Carbonara', 26.9, 'makaron, pieczarki, boczek, parmezan, ??mietana, jajko, mieszanka przypraw', 'Autorska wersja tradycyjnego, w??oskiego przysmaku, wzbogacona o nasze polskie pieczarki. Do tego przepyszny sos na bazie ??????tka i ??mietany. Nie zabrak??o tak??e importowanego z samej Italii boczku. Ta kompozycja sprawi, ??e poczujesz si?? jak w trzygwiazdkowej restauracji w Rzymie. Buon appetito!', 'makaron'),
(12, 'Chow Mein', 40.9, 'nudle orientalne, sos sojowy, kurczak, kapusta, marchew, kie??ki fasoli mung, krewetki, mieszanka przypraw', 'Orientalna propozycja w naszym menu, na wypadek, gdyby ktokolwiek by?? zbytnio znudzony tradycyjn?? kuchni??, ale zbyt biedny, ??eby wybra?? si?? do Azji. Przyrz??dzone na bogato - z mi??sem i krewetkami czyni je najbardziej ekskluzywnym daniem w naszej ofercie. Porzu?? chi??skie zupki i posmakuj prawdziwej Azji!', 'makaron'),
(13, 'Pizza Pepperoni', 28.9, 'dro??d??e, m??ka, s??l, sos pomidorowy, ser mozzarella, pepperoni, mieszanka przypraw', 'Najbardziej klasyczna z naszego zestawienia. Mo??na j?? zam??wi?? na imprez?? i nikt nie b??dzie narzeka??, ??e takiej to on nie zje. Chyba ??e nie je mi??sa, to niech zdejmie kie??bask??. Pieczona w kaflowym piecu, jej ciasto wytwarzane jest na postawie tradycyjnej, w??oskiej receptury. Jej ??rednica to 32cm.', 'pizza'),
(14, 'Pizza Hawajska', 29.9, 'dro??d??e, m??ka, s??l, sos pomidorowy, ser mozzarella, bekon, ananas, mieszanka przypraw', 'Mo??na j?? kocha??, albo nienawidzi??. My jeste??my ponad podzia??ami, kto ch??tny, niech zamawia. Ananas ??wie??y, z importu, niepuszkowany. Pieczona w kaflowym piecu, jej ciasto wytwarzane jest na postawie tradycyjnej, w??oskiej receptury. Jej ??rednica to 32cm.', 'pizza'),
(15, 'Pizza na bogato', 35.9, 'dro??d??e, m??ka, s??l, sos pomidorowy, ser mozzarella, pepperoni, mi??so wo??owe, pieczarki, czerwona cebula, papryka, mieszanka przypraw', 'Dla wiecznych g??odomor??w, kt??rzy na pytanie \"Z czym chcesz pizz??\" odpowiadaj?? \"Tak.\". Znajdziecie na niej dwa rodzaje mi??sa, warzywa i pieczarki. Czego chcie?? wi??cej? Pieczona w kaflowym piecu, jej ciasto wytwarzane jest na postawie tradycyjnej, w??oskiej receptury. Jej ??rednica to 32cm.', 'pizza'),
(16, 'Frytki', 6.9, 'ziemniaki, ketchup, s??l', 'Kto nie lubi frytek? Ziemniaki s?? najlepszym darem naszej planety, gdy?? w ka??dej formie smakuj?? wy??mienicie. A w formie d??ugich, sma??onych fryteczek najlepiej. Mo??esz zam??wi?? je jako dodatek do dania lub osobno, w ko??cu to ??aden wstyd zje???? tylko talerz frytek. Albo dwa talerze. Podawane z ketchupem.', 'dodatki'),
(17, 'Ry??', 5.9, 'ry??, marchewka, groszek', 'Dla wybrednych, os??b na diecie, lub azjat??w. Ry?? gotowany z marchewk?? i groszkiem stanowi idealny dodatek do chow_mein lub ryby. Chyba, ??e kto?? jest fanatykiem ry??u, ca??e mieszkanie zawalone pude??kami... to wtedy smacznego!', 'dodatki'),
(18, 'Sa??atka', 7.9, 'mieszanka sa??at, pomidor, szpinak', 'Du??a porcja warzyw dla wegetarianina, osoby, kt??ra si?? zdrowo od??ywia lub ??asucha, kt??remu sam kurczak z ziemniakami nie wystarczy. ??wie??a mieszanka sa??at doda koloru ka??demu daniu z naszej oferty.', 'dodatki'),
(19, 'Cola', 5.9, 'Podane na opakowaniu', 'Dla fan??w walki Cola vs Pepsi, zawodnik w czerwonych barwach. Coli nie trzeba nikomu przedstawia??, Br??zowy, s??odki, gazowany p??yn, kt??ry idealnie gasi pragnienie. Czy to samo napisali??my o Coli? Hmm, nic nie wiemy na ten temat... Puszka 0,33l.', 'napoje'),
(20, 'Pepsi', 5.9, 'Podane na opakowaniu', 'Dla fan??w walki Cola vs Pepsi, zawodnik w niebieskich barwach. Pepsi nie trzeba nikomu przedstawia??, Br??zowy, s??odki, gazowany p??yn, kt??ry idealnie gasi pragnienie. Czy to samo napisali??my o Coli? Hmm, nic nie wiemy na ten temat... Puszka 0,33l.', 'napoje'),
(21, 'Sprite', 5.9, 'Podane na opakowaniu', 'Masz ju?? do???? odwiecznego sporu Cola czy Pepsi? Napij si?? Sprite\'a! Nie tylko doskonale gasi pragnienie, ale te?? idealnie orze??wia i nadaje si?? jako baza pod wiele drink??w! Puszka 0,33l.', 'napoje'),
(22, 'Woda', 5.9, '100% woda mineralna.', 'Co tu du??o m??wi??... woda. Woda mineralna, taka jak wsz??dzie, chocia?? i tak si?? znajdzie jakis smakosz, kt??ry powie ??e to nie to samo perlage jakie pi?? w Pary??u w 80-tym. C????. Cieszymy si??, ??e ma Pan takie pami??tliwe kubki smakowe, natomiast dla wszystkich  pozosta??ych: Woda w butelce 0,5l.', 'napoje'),
(23, 'Sok pomara??czowy', 5.9, '100% sok z pomara??czy', '??wie??o wyciskany sok pomara??czowy jest zdrow?? alternatyw?? dla s??odkich, gazowanych napoj??w. Pomara??cze od po??udniowego dostawcy, prosto z ciep??ego kraju zapewni?? dzienn?? porcj?? witamin ka??demu, kto spr??buje soku. Szklanka 0,3l. ', 'napoje');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `orders`
--

CREATE TABLE `orders` (
  `order_id` int NOT NULL,
  `order_user_id` int NOT NULL,
  `total_price` float DEFAULT NULL,
  `status` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `comments` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `time` datetime NOT NULL
) ;

--
-- Zrzut danych tabeli `orders`
--

INSERT INTO `orders` (`order_id`, `order_user_id`, `total_price`, `status`, `comments`, `time`) VALUES
(31, 1, 289.5, 'dostarczone', 'sdadas', '2021-12-29 11:04:09'),
(32, 1, 289.5, 'dostarczone', 'sdadas', '2021-12-29 11:04:24'),
(33, 22, 51.7, 'dostarczone', NULL, '2021-12-29 12:51:27'),
(34, 1, 289.5, 'dostarczone', 'sdadas', '2021-12-29 14:15:22'),
(35, 1, 289.5, 'dostarczone', 'sdadas', '2021-12-29 14:23:15'),
(36, 22, 129.5, 'dostarczone', NULL, '2021-12-29 18:37:45'),
(37, 22, 61.7, 'dostarczone', NULL, '2021-12-29 19:11:29'),
(38, 22, 0, 'dostarczone', NULL, '2022-01-04 21:00:40'),
(39, 22, 100.6, 'dostarczone', 'Z kotkami\n\n', '2022-01-04 21:07:59'),
(40, 22, 77.4, 'dostarczone', NULL, '2022-01-04 21:11:10'),
(41, 22, 0, 'dostarczone', NULL, '2022-01-04 21:27:09'),
(42, 22, 29.7, 'dostarczone', NULL, '2022-01-21 13:01:02'),
(43, 67, 146.4, 'dostarczone', NULL, '2022-01-25 17:56:02'),
(44, 67, 25.8, 'dostarczone', NULL, '2022-01-25 17:59:17'),
(45, 75, 29.7, 'dostarczone', NULL, '2022-01-25 18:36:49'),
(46, 78, 76.7, 'w przygotowaniu', NULL, '2022-01-25 19:24:32');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `orders_details`
--

CREATE TABLE `orders_details` (
  `order_id` int DEFAULT NULL,
  `food_id` int DEFAULT NULL,
  `amount` int DEFAULT NULL,
  `price` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Zrzut danych tabeli `orders_details`
--

INSERT INTO `orders_details` (`order_id`, `food_id`, `amount`, `price`) VALUES
(31, 1, 1, 9.9),
(31, 2, 2, 25.8),
(31, 3, 3, 77.7),
(31, 4, 4, 91.6),
(31, 5, 5, 84.5),
(32, 1, 1, 9.9),
(32, 2, 2, 25.8),
(32, 3, 3, 77.7),
(32, 4, 4, 91.6),
(32, 5, 5, 84.5),
(33, 2, 2, 25.8),
(33, 3, 1, 25.9),
(34, 1, 1, 9.9),
(34, 2, 2, 25.8),
(34, 3, 3, 77.7),
(34, 4, 4, 91.6),
(34, 5, 5, 84.5),
(35, 1, 1, 9.9),
(35, 2, 2, 25.8),
(35, 3, 3, 77.7),
(35, 4, 4, 91.6),
(35, 5, 5, 84.5),
(36, 3, 5, 129.5),
(37, 3, 1, 25.9),
(37, 4, 1, 22.9),
(37, 2, 1, 12.9),
(39, 1, 2, 19.8),
(39, 6, 1, 50),
(39, 9, 1, 30.8),
(40, 2, 6, 77.4),
(42, 1, 3, 29.7),
(43, 3, 3, 77.7),
(43, 4, 3, 68.7),
(44, 2, 2, 25.8),
(45, 1, 3, 29.7),
(46, 10, 2, 49.8),
(46, 11, 1, 26.9);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `reservations`
--

CREATE TABLE `reservations` (
  `reserv_id` int NOT NULL,
  `reserv_user` int DEFAULT NULL,
  `reserv_table` int DEFAULT NULL,
  `time` datetime NOT NULL,
  `comments` text COLLATE utf8mb4_unicode_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Zrzut danych tabeli `reservations`
--

INSERT INTO `reservations` (`reserv_id`, `reserv_user`, `reserv_table`, `time`, `comments`) VALUES
(1, 10, 1, '2021-12-30 15:00:00', NULL),
(2, 10, 1, '2021-12-30 19:00:00', NULL),
(3, 10, 1, '2021-12-30 17:00:00', NULL),
(4, 10, 2, '2021-12-30 17:30:00', NULL),
(5, 10, 5, '2021-12-30 18:30:00', NULL),
(6, 22, 12, '2022-01-10 15:00:00', NULL),
(7, 22, 8, '2022-01-10 15:00:00', NULL),
(8, 22, 10, '2022-01-10 16:00:00', NULL),
(9, 67, 11, '2022-01-27 16:00:00', NULL),
(10, 75, 10, '2022-01-27 15:00:00', NULL),
(11, 78, 12, '2022-01-27 16:00:00', NULL);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `tables`
--

CREATE TABLE `tables` (
  `table_id` int NOT NULL,
  `space` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Zrzut danych tabeli `tables`
--

INSERT INTO `tables` (`table_id`, `space`) VALUES
(1, 2),
(2, 2),
(3, 2),
(4, 2),
(5, 2),
(6, 2),
(7, 4),
(8, 4),
(9, 4),
(10, 6),
(11, 6),
(12, 6),
(13, 7);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `users`
--

CREATE TABLE `users` (
  `user_id` int NOT NULL,
  `name` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  `lastname` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(70) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `street` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `house_nr` int NOT NULL,
  `apartment_nr` int DEFAULT NULL,
  `postal_code` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  `city` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone_nr` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Zrzut danych tabeli `users`
--

INSERT INTO `users` (`user_id`, `name`, `lastname`, `email`, `password`, `street`, `house_nr`, `apartment_nr`, `postal_code`, `city`, `phone_nr`) VALUES
(1, 'Dawiod', 'Dzh', 'daw@gmail.com', 'lolek', 'Konpia', 4, 8, '34--500', 'zakopane', 555666777),
(2, 'justa', 'g', 'jg@kotki.com', 'kotki', 'st', 26, 8, '31-032', 'Krak??w', 111111111),
(10, 'Zbysiu', 'Zz??bysi??', 'email', 'lolek', '??bysi??ki', 5, NULL, '34-456', '??ywi??c', 454545450),
(11, 'Lolek', 'Bolek', 'dobry@dsfkjh.com', 'asdsad', 'Wojna', 5, 5, '34-500', 'Mojze', 111222333),
(14, 'Lolek', 'Bolek', 'dobry2@dsfkjh.com', 'asdsad', 'fojna', 5, 5, '34-500', 'Mojze', 111222334),
(16, 'Bub', 'Dod', 'email22', 'dsa', 'Wojna', 5, 5, 'ssdd', 'Daaaa', 333111222),
(19, 'Loelk', 'Bolek', 'lololol@gmaaail.com', '$2y$10$6zkVb2iJ89krrwjJ7NJXq.asKj8MXSgmKdyrWk2o0yIgzQ3mdr.Ym', 'Slowacka', 7, 10, '45-345', 'Mordkaa', 111000555),
(20, 'Jjj', 'Jjj', 'jjj@jjj.com', '$2y$10$SklASxDRqTCYYV7dvHS/zOqoIcCUGUyebI3vj./qhQyPDKbKBeUwm', 'Jjj', 2, 3, '22-222', 'Kkk', 555555555),
(22, 'Ja', 'Gie', 'kotki@mniam.com', '$2y$10$fxZ2GOQtLBpp0w7qtE0tUOUtAI/M0J98I0MMva2TQ7YxX/qpo7RvC', 'Ulicaaaaa', 5, 2, '33-333', 'Krakow', 123456000),
(52, 'Temporara', 'Temp', 'temp003@gmail.com', '$2y$10$zkiDlE3s0tP6/gmX7muU2O/fl78bKq5YbikJQrR3mQuGlxzi5MPMq', 'Tymczasowa', 10, 2, '11-111', 'Oleksy', 718920364),
(56, 'Temporara', 'Temp', 'temp004@gmail.com', '$2y$10$4YFYmmBvBhKLnB7nxAtq2ep3zCc9EtFnY7g9fc06bDiyc2HcbgxAm', 'Tymczasowa', 11, 2, '11-111', 'Oleksy', 718920365),
(64, 'Hej', 'Maslo', 'hejhej@hej.com', '$2y$10$pKE6g8KmLkfDvOM/LQukv.pW1hlOSdylMap3YBdCOcue6z2UCnkUi', 'Moslowa', 2, 22, '31-111', 'Maslowe', 829019826),
(65, 'Testowe', 'Test', 'test2@test.com', '$2y$10$McM/sURR4LnEeVKorYocq.LQGU4rBVyoyrD/.NE6cyC6ou7zd7e/q', 'Testo', 2, 2, '33-333', 'Test', 123456111),
(66, 'Janko', 'Kowalski', 'jan@kowalski.com', '$2y$10$vsrR0qBAsncZFLEDMhJ0UujfTWaftzzsVfiFNJhI0PR2q82fakpH2', 'Debowa', 5, 15, '31-312', 'Krakow', 999222065),
(67, 'Anna', 'Nowak', 'anna@nowak.com', '$2y$10$XrX/kBcb9.eRH3UwEDPPAuxdklSPeQc8ETmHItzHvZZ9gG05k4sou', 'Mysia', 6, 3, '32-222', 'Kotki', 678102392),
(68, 'Nina', 'Kaliente', 'tescik5@gmail.com', '$2y$10$2tcbzdBpnr82qpLvPaRhweAOzBOiSGSdClS8obY0dX0Rb2zhVpTa.', 'Dziwna', 234, NULL, '11-111', 'Oleksy', 110099913),
(69, 'Ninaaa', 'Kalienteee', 'tescik544@gmail.com', '$2y$10$3MRgzjfAirdcKhZnOhibbOVLHTU1j8Yng7JRAMTyTYe8ncRLez9ny', 'Dziwna', 234, NULL, '33-333', 'Dziwne', 590178394),
(72, 'Ninaaar', 'Kalienteeer', 'tescik54444@gmail.com', '$2y$10$p.UlH7W4jT6ef.JhYPSxR.xP7i.zlhm6aApBnyr/P3Ugix6nIUtGm', 'Dziwna', 234, NULL, '33-333', 'Dziwne', 590178393),
(73, 'Bubyyy', 'Dodaaaa', 'emailsdf@gmail.com', 'dsasad3333', '??a??osna', 5, NULL, '23-492', 'Daaaa', 100200300),
(74, 'Dina', 'Nina', 'dina@nina.com', '$2y$10$Em7ikxrUpskfIQsaVu0n3uohBRDvBg.9jxZOfHyH2ceORkSqmrmDG', 'Fajna', 5, NULL, '55-555', 'Fajne', 109784938),
(75, 'Mail', 'Mailowy', 'moj@mail.com', '$2y$10$ZB2JfmPi0YYRonKl6JDNHO2gFzAYW5NiG9QtmCJS2I3hJH731013m', 'Mailowa', 5, NULL, '44-655', 'Fsjne', 546093445),
(76, 'Kicia', 'Kocia', 'kici@koci.kotki', '$2y$10$2P5aGrFUk6CddDqIgfMe.OazgjTH5yFDHuqEYNuv5BOellpvqE9vK', 'Kitkowa', 3, 3, '54-095', 'Kotowice', 906728394),
(77, 'Natalia', 'Nataliowska', 'na@ta.lia', '$2y$10$Ed.GbEiqaZA1D1Sjsb.jruQVyt2wOcU2tIOh5E51rOamUv76vdh42', 'Natalewa', 5, 5, '80-987', 'Natalowice', 619827364),
(78, 'Justyna', 'Greda', 'justyna@greda.com', '$2y$10$JgDmGPyY/tmZVwi4Cp7/O.PgtXFGQjIUUKEVnk9eBu/aC1VJ4VM9u', 'Ulica', 3, 4, '55-555', 'Krakow', 906782998);

--
-- Wyzwalacze `users`
--
DELIMITER $$
CREATE TRIGGER `check_city` BEFORE INSERT ON `users` FOR EACH ROW BEGIN
  IF (REGEXP_LIKE(NEW.city, '^[A-Z??????????????????]{1}[a-z??????????????????]*$', 'c') = 0)    THEN 
  SIGNAL SQLSTATE '45000'
  set message_text = '5';
  END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `check_lastname` BEFORE INSERT ON `users` FOR EACH ROW BEGIN
  IF (REGEXP_LIKE(NEW.lastname, '^[A-Z??????????????????]{1}[a-z??????????????????]*$', 'c') = 0)    THEN 
  SIGNAL SQLSTATE '45000'
  set message_text = '2';
  END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `check_name` BEFORE INSERT ON `users` FOR EACH ROW BEGIN
  IF (REGEXP_LIKE(NEW.name, '^[A-Z??????????????????]{1}[a-z??????????????????]*$', 'c') = 0)   THEN 
  SIGNAL SQLSTATE '45000'
  set message_text = '1';
  END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `check_phone_nr` BEFORE INSERT ON `users` FOR EACH ROW BEGIN
  IF (NEW.phone_nr NOT REGEXP  '^[0-9]{9}$')    THEN 
  SIGNAL SQLSTATE '45000'
  set message_text = '6';
  END IF;
  IF (EXISTS(SELECT 1 FROM users WHERE phone_nr = NEW.phone_nr)) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '6';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `check_postal_code` BEFORE INSERT ON `users` FOR EACH ROW BEGIN
  IF (NEW.postal_code NOT REGEXP  '^[0-9]{2}-[0-9]{3}$')    THEN 
  SIGNAL SQLSTATE '45000'
  set message_text = '4';
  END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `check_street` BEFORE INSERT ON `users` FOR EACH ROW BEGIN
  IF (REGEXP_LIKE(NEW.street, '^[A-Z??????????????????]{1}[a-z??????????????????]*$', 'c') = 0)   THEN 
  SIGNAL SQLSTATE '45000'
  set message_text = '3';
  END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `up_check_city` BEFORE UPDATE ON `users` FOR EACH ROW BEGIN
  IF (REGEXP_LIKE(NEW.city, '^[A-Z??????????????????]{1}[a-z??????????????????]*$', 'c') = 0)  THEN 
  SIGNAL SQLSTATE '45000'
  set message_text = '5';
  END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `up_check_lastname` BEFORE UPDATE ON `users` FOR EACH ROW BEGIN
  IF (REGEXP_LIKE(NEW.lastname, '^[A-Z??????????????????]{1}[a-z??????????????????]*$', 'c') = 0)    THEN 
  SIGNAL SQLSTATE '45000'
  set message_text = '2';
  END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `up_check_name` BEFORE UPDATE ON `users` FOR EACH ROW BEGIN
  IF (REGEXP_LIKE(NEW.name, '^[A-Z??????????????????]{1}[a-z??????????????????]*$', 'c') = 0)    THEN 
  SIGNAL SQLSTATE '45000'
  set message_text = '1';
  END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `up_check_phone_nr` BEFORE UPDATE ON `users` FOR EACH ROW BEGIN
  IF (NEW.phone_nr NOT REGEXP  '^[0-9]{9}$')    THEN 
  SIGNAL SQLSTATE '45000'
  set message_text = '6';
  END IF;
  IF (EXISTS(SELECT 1 FROM users WHERE phone_nr = NEW.phone_nr AND name  != NEW.name AND lastname != NEW.lastname)) THEN
    SIGNAL SQLSTATE VALUE '45000' SET MESSAGE_TEXT = '6';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `up_check_postal_code` BEFORE UPDATE ON `users` FOR EACH ROW BEGIN
  IF (NEW.postal_code NOT REGEXP  '^[0-9]{2}-[0-9]{3}$')    THEN 
  SIGNAL SQLSTATE '45000'
  set message_text = '4';
  END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `up_check_street` BEFORE UPDATE ON `users` FOR EACH ROW BEGIN
  IF (REGEXP_LIKE(NEW.street, '^[A-Z??????????????????]{1}[a-z??????????????????]*$', 'c') = 0)   THEN 
  SIGNAL SQLSTATE '45000'
  set message_text = '3';
  END IF;
END
$$
DELIMITER ;

--
-- Indeksy dla zrzut??w tabel
--

--
-- Indeksy dla tabeli `menu`
--
ALTER TABLE `menu`
  ADD PRIMARY KEY (`food_id`);

--
-- Indeksy dla tabeli `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `order_user_idx` (`order_user_id`);

--
-- Indeksy dla tabeli `orders_details`
--
ALTER TABLE `orders_details`
  ADD KEY `food_id_idx` (`food_id`),
  ADD KEY `order_id` (`order_id`);

--
-- Indeksy dla tabeli `reservations`
--
ALTER TABLE `reservations`
  ADD PRIMARY KEY (`reserv_id`),
  ADD KEY `reserv_table_idx` (`reserv_table`),
  ADD KEY `reserv_user_idx` (`reserv_user`);

--
-- Indeksy dla tabeli `tables`
--
ALTER TABLE `tables`
  ADD PRIMARY KEY (`table_id`);

--
-- Indeksy dla tabeli `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `username_UNIQUE` (`email`),
  ADD UNIQUE KEY `phone_nr_UNIQUE` (`phone_nr`),
  ADD UNIQUE KEY `unq_us` (`name`,`lastname`,`street`,`house_nr`,`city`) USING BTREE;

--
-- AUTO_INCREMENT dla zrzuconych tabel
--

--
-- AUTO_INCREMENT dla tabeli `orders`
--
ALTER TABLE `orders`
  MODIFY `order_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT dla tabeli `reservations`
--
ALTER TABLE `reservations`
  MODIFY `reserv_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT dla tabeli `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=79;

--
-- Ograniczenia dla zrzut??w tabel
--

--
-- Ograniczenia dla tabeli `orders_details`
--
ALTER TABLE `orders_details`
  ADD CONSTRAINT `food_id` FOREIGN KEY (`food_id`) REFERENCES `menu` (`food_id`),
  ADD CONSTRAINT `order_id` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`);

--
-- Ograniczenia dla tabeli `reservations`
--
ALTER TABLE `reservations`
  ADD CONSTRAINT `reserv_table` FOREIGN KEY (`reserv_table`) REFERENCES `tables` (`table_id`),
  ADD CONSTRAINT `reserv_user` FOREIGN KEY (`reserv_user`) REFERENCES `users` (`user_id`);

DELIMITER $$
--
-- Zdarzenia
--
CREATE DEFINER=`s402639`@`localhost` EVENT `update_status_event` ON SCHEDULE EVERY 10 SECOND STARTS '2021-12-29 14:51:20' ON COMPLETION NOT PRESERVE ENABLE DO SELECT update_status_fun()$$

DELIMITER ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
