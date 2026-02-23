import streamlit as st
import requests

# Настройка страницы
st.set_page_config(page_title="WB Аналитик", page_icon="📈")

st.title("🚀 Анализатор товаров Wildberries")
st.write("Вставь артикул товара, чтобы получить скрытые данные.")

# Поле ввода
article = st.text_input("Введите артикул (например: 21169516)", "")

if article:
    try:
        url = f"https://card.wb.ru{article}"
        headers = {"User-Agent": "Mozilla/5.0"}
        
        response = requests.get(url, headers=headers, timeout=10)
        data = response.json()
        products = data.get('data', {}).get('products', [])

        if products:
            item = products[0]
            
            # Верстка карточки товара
            col1, col2 = st.columns(2)
            
            with col1:
                st.subheader(item.get('name'))
                st.write(f"**Бренд:** {item.get('brand')}")
                st.write(f"**Рейтинг:** ⭐ {item.get('reviewRating')}")
                st.write(f"**Отзывов:** {item.get('feedbacks')}")

            with col2:
                price = item.get('salePriceU', 0) // 100
                st.metric("Цена сейчас", f"{price} ₽")
                
                # Фишка: расчет потенциальной прибыли или остатков
                st.info(f"Артикул проверен успешно!")
        else:
            st.error("Товар не найден. Проверь артикул.")
            
    except Exception as e:
        st.error(f"Ошибка связи с сервером. Попробуйте позже.")
