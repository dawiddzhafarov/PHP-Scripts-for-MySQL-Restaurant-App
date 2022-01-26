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
(1, 'Stripsy', 9.9, 'kurczak, bułka tarta, płatki kukurydziane jajko, mieszanka przypraw', 'Pyszne kawałki kurczaka w złocistej panierce. Są tak chrupiące, że sąsiedzi będą pytać, kto robi remont w mieszkaniu. Idealny smak zapewnia im odpowiednia mieszanka przypraw oraz tajemniczy składnik - miłość, z jaką przygotowujemy wszystkie nasze dania. Przystępne cenowo, \r\nzapewnią każdemu łasuchowi szybką przegryzkę!', 'fast'),
(2, 'Burrito', 12.9, 'stripsy z kurczaka, sałata, cebula, papryka, ser cheddar, majonez, ketchup', 'Czy zatęskniłeś za czasem spędzonym w łonie matki, kiedy otulony miłością i ciepłem mogłeś sobie leżeć i nic nie robić? Właśnie tak czuje się wnętrze naszego burrito! Wypełnione po brzegi dodatkami sprawi, że powrócisz myślami do tamtych czasów. Uwaga - żadne składniki nie wypadają z wnętrza naszej przekąski, abyś mógł cieszyć się higienicznym spożywaniem posiłku!', 'fast'),
(3, 'Burger', 25.9, 'bułka, sezam, mięso mielone wołowe, boczek, ser cheddar, grillowany ser, ketchup, pikle, cebula, pomidor, sałata, tajemniczy sos', 'Masz ochotę na coś wielkiego i pełnego smaku? Wstąp po naszego burgera! To aż 13 warstw rozkoszy dla podniebienia i mnóstwo kalorii, które zaspokoją nawet największy głód. Kanapka jest zawsze świeża i ciepła, tak wysoka, że żadna ilość botoksu nie pozwoli ci jej zmieścić na raz w ustach. Symfonię smaków dopełnia tajemny sos, którego receptura została opracowana przez nas, dla was.', 'kanapka'),
(4, 'Chicken Burger', 22.9, 'bułka, sezam, sałata, stripsy z kurczaka, ser cheddar, prażona cebulka, tajemniczy sos', 'Z jakiegoś powodu martwisz się o życie krówek? Spokojnie, mamy coś dla ciebie! Chicken burger to kanapka wypełniona wielkim kotletem z kurczaka, co czyni ją lżejszą od tradycyjnego burgera. Nie ma w sobie tylu warstw, pozostał w niej jednak wyjątkowy smak, który nadaje jej nasz tajemniczy sos. Burger jest też szczególnie chrupiący za sprawą prażonej cebulki.', 'kanapka'),
(5, 'Sandwich', 16.9, 'szynka, ser żółty, pomidor, sałata, musztarda, miód, bułka', 'Brakuje ci czasów, kiedy mama pakowała ci kanapki do szkoły? Żaden problem! Nasz sandwich sprawi, że poczujesz się jak w 7 klasie, kiedy wymieniałeś kanapkę z pasztetem na taką z dżemem. Z tym że u nas nie ma dżemu. Są za to pełnowartościowe warzywa, plastry szynki oraz przepyszny sos miodowo-musztardowy. A to wszystko otulone grillowaną bułką. I co, nadal chcesz się zamienić?', 'kanapka'),
(6, 'Kurczak', 50, 'kurczak, ziemniaki, mieszanka przypraw, czosnek, miód, musztarda', 'Danie dla największego głodomora. To zwyczajnie cały kurczak upieczony na rożnie, aby swoim soczystym mięskiem łaskotać kubki smakowe naszych klientów. Jego złocista skórka uzyskana za pomocą kilkunastogodzinnego marynowania to efekt naszych prac nad recepturą, która zadowoli nawet najbardziej wybrednych klientów. Przyrządzany z czosnkiem, podawany z pieczonymi ziemniakami.', 'danie'),
(7, 'Ryba', 40.8, 'ryba, ryż, groszek, marchew, papryka, kapusta, awokado, limonka, mieszanka przypraw', 'Jesteś fanem darów morza? Zapraszamy na naszą rybkę! Jej ostatnim życzeniem było, żeby taki smakosz jak ty mógł się nią posilić! Wielki okaz od lokalnego dostawcy, idealnie przyrządzony na grilu i doprawiony. Smaku dodaje limonka, którą należy skropić rybę przez spożyciem. Podawana z ryżem i sałatką z awokado, papryki i kapusty. ', 'danie'),
(8, 'Szaszłyki', 32.8, 'jagnięcina, czosnek, ogórek kiszony, pomidor, mieszanka przypraw', 'Masz obsesję na punkcie układania równo przedmiotów? Szaszłyk to idealna kompozycja dla ciebie! Przyrządzony z mięsa jagnięcego składa się z naprzemiennej kombinacji: mięso, czosnek, ogórek, pomidor. Mięso, czosnek... i tak dalej. Dopilnujemy, żeby kucharz nie pomylił się w tej kolejności.', 'danie'),
(9, 'Kebab', 30.8, 'mięso wołowe, ziemniaki, cebula czerwona, sałata, kapusta czerwona ogórek kiszony, pomidor, majonez, czosnek, chili, mieszanka przypraw', 'Czym by była knajpa bez kebabu? U nas podawany jest on w bogatej wersji, bez żadnego owijania w... tortillę. Wszystko leży na talerzu i czeka, aż ktoś się tym zajmie. Tradycyjnie, smaku doda nasz tradycyjny, polski ogórek kiszony, a pikanterii nasz autorski sos czosnkowo-majonezowo-paprykowy. Ogniste wrażenia murowane! Podawany z frytkami, sosem i sałatką.', 'danie'),
(10, 'Spaghetti', 24.9, 'makaron, mięso wieprzowe, pomidory, parmezan, mieszanka przypraw', 'Powiew Italii w naszej restauracji! To klasyczny, znany wszystkim makaron z sosem pomidorowym. Kucharz nie łamał jak gotował. Potężna porcja długiego makaronu z wolnogotowanym sosem i idealnie doprawionym mięsem. A to wszystko pod pierzynką z prawdziwego parmezanu. Mamma mia!', 'makaron'),
(11, 'Carbonara', 26.9, 'makaron, pieczarki, boczek, parmezan, śmietana, jajko, mieszanka przypraw', 'Autorska wersja tradycyjnego, włoskiego przysmaku, wzbogacona o nasze polskie pieczarki. Do tego przepyszny sos na bazie żółtka i śmietany. Nie zabrakło także importowanego z samej Italii boczku. Ta kompozycja sprawi, że poczujesz się jak w trzygwiazdkowej restauracji w Rzymie. Buon appetito!', 'makaron'),
(12, 'Chow Mein', 40.9, 'nudle orientalne, sos sojowy, kurczak, kapusta, marchew, kiełki fasoli mung, krewetki, mieszanka przypraw', 'Orientalna propozycja w naszym menu, na wypadek, gdyby ktokolwiek był zbytnio znudzony tradycyjną kuchnią, ale zbyt biedny, żeby wybrać się do Azji. Przyrządzone na bogato - z mięsem i krewetkami czyni je najbardziej ekskluzywnym daniem w naszej ofercie. Porzuć chińskie zupki i posmakuj prawdziwej Azji!', 'makaron'),
(13, 'Pizza Pepperoni', 28.9, 'drożdże, mąka, sól, sos pomidorowy, ser mozzarella, pepperoni, mieszanka przypraw', 'Najbardziej klasyczna z naszego zestawienia. Można ją zamówić na imprezę i nikt nie będzie narzekał, że takiej to on nie zje. Chyba że nie je mięsa, to niech zdejmie kiełbaskę. Pieczona w kaflowym piecu, jej ciasto wytwarzane jest na postawie tradycyjnej, włoskiej receptury. Jej średnica to 32cm.', 'pizza'),
(14, 'Pizza Hawajska', 29.9, 'drożdże, mąka, sól, sos pomidorowy, ser mozzarella, bekon, ananas, mieszanka przypraw', 'Można ją kochać, albo nienawidzić. My jesteśmy ponad podziałami, kto chętny, niech zamawia. Ananas świeży, z importu, niepuszkowany. Pieczona w kaflowym piecu, jej ciasto wytwarzane jest na postawie tradycyjnej, włoskiej receptury. Jej średnica to 32cm.', 'pizza'),
(15, 'Pizza na bogato', 35.9, 'drożdże, mąka, sól, sos pomidorowy, ser mozzarella, pepperoni, mięso wołowe, pieczarki, czerwona cebula, papryka, mieszanka przypraw', 'Dla wiecznych głodomorów, którzy na pytanie \"Z czym chcesz pizzę\" odpowiadają \"Tak.\". Znajdziecie na niej dwa rodzaje mięsa, warzywa i pieczarki. Czego chcieć więcej? Pieczona w kaflowym piecu, jej ciasto wytwarzane jest na postawie tradycyjnej, włoskiej receptury. Jej średnica to 32cm.', 'pizza'),
(16, 'Frytki', 6.9, 'ziemniaki, ketchup, sól', 'Kto nie lubi frytek? Ziemniaki są najlepszym darem naszej planety, gdyż w każdej formie smakują wyśmienicie. A w formie długich, smażonych fryteczek najlepiej. Możesz zamówić je jako dodatek do dania lub osobno, w końcu to żaden wstyd zjeść tylko talerz frytek. Albo dwa talerze. Podawane z ketchupem.', 'dodatki'),
(17, 'Ryż', 5.9, 'ryż, marchewka, groszek', 'Dla wybrednych, osób na diecie, lub azjatów. Ryż gotowany z marchewką i groszkiem stanowi idealny dodatek do chow_mein lub ryby. Chyba, że ktoś jest fanatykiem ryżu, całe mieszkanie zawalone pudełkami... to wtedy smacznego!', 'dodatki'),
(18, 'Sałatka', 7.9, 'mieszanka sałat, pomidor, szpinak', 'Duża porcja warzyw dla wegetarianina, osoby, która się zdrowo odżywia lub łasucha, któremu sam kurczak z ziemniakami nie wystarczy. Świeża mieszanka sałat doda koloru każdemu daniu z naszej oferty.', 'dodatki'),
(19, 'Cola', 5.9, 'Podane na opakowaniu', 'Dla fanów walki Cola vs Pepsi, zawodnik w czerwonych barwach. Coli nie trzeba nikomu przedstawiać, Brązowy, słodki, gazowany płyn, który idealnie gasi pragnienie. Czy to samo napisaliśmy o Coli? Hmm, nic nie wiemy na ten temat... Puszka 0,33l.', 'napoje'),
(20, 'Pepsi', 5.9, 'Podane na opakowaniu', 'Dla fanów walki Cola vs Pepsi, zawodnik w niebieskich barwach. Pepsi nie trzeba nikomu przedstawiać, Brązowy, słodki, gazowany płyn, który idealnie gasi pragnienie. Czy to samo napisaliśmy o Coli? Hmm, nic nie wiemy na ten temat... Puszka 0,33l.', 'napoje'),
(21, 'Sprite', 5.9, 'Podane na opakowaniu', 'Masz już dość odwiecznego sporu Cola czy Pepsi? Napij się Sprite\'a! Nie tylko doskonale gasi pragnienie, ale też idealnie orzeźwia i nadaje się jako baza pod wiele drinków! Puszka 0,33l.', 'napoje'),
(22, 'Woda', 5.9, '100% woda mineralna.', 'Co tu dużo mówić... woda. Woda mineralna, taka jak wszędzie, chociaż i tak się znajdzie jakis smakosz, który powie że to nie to samo perlage jakie pił w Paryżu w 80-tym. Cóż. Cieszymy się, że ma Pan takie pamiętliwe kubki smakowe, natomiast dla wszystkich  pozostałych: Woda w butelce 0,5l.', 'napoje'),
(23, 'Sok pomarańczowy', 5.9, '100% sok z pomarańczy', 'Świeżo wyciskany sok pomarańczowy jest zdrową alternatywą dla słodkich, gazowanych napojów. Pomarańcze od południowego dostawcy, prosto z ciepłego kraju zapewnią dzienną porcję witamin każdemu, kto spróbuje soku. Szklanka 0,3l. ', 'napoje');

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
(2, 'justa', 'g', 'jg@kotki.com', 'kotki', 'st', 26, 8, '31-032', 'Kraków', 111111111),
(10, 'Zbysiu', 'Zzżbysię', 'email', 'lolek', 'Żbysięki', 5, NULL, '34-456', 'Żywięc', 454545450),
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
(73, 'Bubyyy', 'Dodaaaa', 'emailsdf@gmail.com', 'dsasad3333', 'Żałosna', 5, NULL, '23-492', 'Daaaa', 100200300),
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
  IF (REGEXP_LIKE(NEW.city, '^[A-ZŻŹĆĄŚĘŁÓŃ]{1}[a-zżźćńółęąś]*$', 'c') = 0)    THEN 
  SIGNAL SQLSTATE '45000'
  set message_text = '5';
  END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `check_lastname` BEFORE INSERT ON `users` FOR EACH ROW BEGIN
  IF (REGEXP_LIKE(NEW.lastname, '^[A-ZŻŹĆĄŚĘŁÓŃ]{1}[a-zżźćńółęąś]*$', 'c') = 0)    THEN 
  SIGNAL SQLSTATE '45000'
  set message_text = '2';
  END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `check_name` BEFORE INSERT ON `users` FOR EACH ROW BEGIN
  IF (REGEXP_LIKE(NEW.name, '^[A-ZŻŹĆĄŚĘŁÓŃ]{1}[a-zżźćńółęąś]*$', 'c') = 0)   THEN 
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
  IF (REGEXP_LIKE(NEW.street, '^[A-ZŻŹĆĄŚĘŁÓŃ]{1}[a-zżźćńółęąś]*$', 'c') = 0)   THEN 
  SIGNAL SQLSTATE '45000'
  set message_text = '3';
  END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `up_check_city` BEFORE UPDATE ON `users` FOR EACH ROW BEGIN
  IF (REGEXP_LIKE(NEW.city, '^[A-ZŻŹĆĄŚĘŁÓŃ]{1}[a-zżźćńółęąś]*$', 'c') = 0)  THEN 
  SIGNAL SQLSTATE '45000'
  set message_text = '5';
  END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `up_check_lastname` BEFORE UPDATE ON `users` FOR EACH ROW BEGIN
  IF (REGEXP_LIKE(NEW.lastname, '^[A-ZŻŹĆĄŚĘŁÓŃ]{1}[a-zżźćńółęąś]*$', 'c') = 0)    THEN 
  SIGNAL SQLSTATE '45000'
  set message_text = '2';
  END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `up_check_name` BEFORE UPDATE ON `users` FOR EACH ROW BEGIN
  IF (REGEXP_LIKE(NEW.name, '^[A-ZŻŹĆĄŚĘŁÓŃ]{1}[a-zżźćńółęąś]*$', 'c') = 0)    THEN 
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
  IF (REGEXP_LIKE(NEW.street, '^[A-ZŻŹĆĄŚĘŁÓŃ]{1}[a-zżźćńółęąś]*$', 'c') = 0)   THEN 
  SIGNAL SQLSTATE '45000'
  set message_text = '3';
  END IF;
END
$$
DELIMITER ;

--
-- Indeksy dla zrzutów tabel
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
-- Ograniczenia dla zrzutów tabel
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
