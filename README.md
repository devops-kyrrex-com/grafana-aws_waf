# grafana-aws_waf

1. Експортуємо айпі адресу інстансу де в нас знаходиться loki
export LOKI_ADDR=http://localhost:3100
2. Пишемо запрос до бази логів loki (приклаз з описами нижче)
logcli query '{service="serviceNameSearch"} |= "login.preCheckEmail.fail" |= "ip"' - limit=500000 - since=721h -o raw > mylog.txt
 - limit=100000 => означає скільки строк логу буде записано в файл
 - since=721h => означає за який проміжок часу будуть оброблені логи
3. Після скачування лог файлу, виконуеться пайтон код який робить три наступні дії:
1) Дістає з лог файлу айпі адресу
2) Додає маску мережі 32 (що обов'язково потрібно для передаці в terraform створення aws_wafv2_ip_set)
3) З пулу всіх строк які будуть дорівнювати кількості встановленому числу у прапорі - limit вибирає лише унікальні айпі адреси і записує їх у файл
