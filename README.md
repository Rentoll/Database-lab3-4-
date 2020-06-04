# Database-lab3-4-
База данных содержащая покупателей, дистрибьюторов, машины и заказы на эти самые машины.
4 таблицы

Consumers: ID | Name | Address 

Distributor: ID | CompanyName | Address

Cars: ID | Name | Price

Orders: Consumer_id | Distributor_id | Car_id | Number_of_cars | Total(заполняется только триггером) | Date

БД находится в `3НФ` так как каждый неключевой атрибут представляет информацию о ключе и ни о чём кроме ключа
