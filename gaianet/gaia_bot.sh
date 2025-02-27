#!/bin/bash

curl -s https://raw.githubusercontent.com/NodEligible/programs/refs/heads/main/display_logo.sh | bash

YELLOW='\e[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}📝 Создание конфигурации...${NC}"

mkdir -p ~/gaia-bot
cd ~/gaia-bot
        
# Добавление фраз в phrases.txt
echo -e "\"What are the latest advancements in quantum computing?\"" > phrases.txt
echo -e "\"How does artificial intelligence impact climate change solutions?\"" >> phrases.txt
echo -e "\"What are the ethical considerations of gene editing technologies?\"" >> phrases.txt
echo -e "\"How can blockchain technology improve supply chain transparency?\"" >> phrases.txt
echo -e "\"What are the potential benefits and risks of autonomous vehicles?\"" >> phrases.txt
echo -e "\"How does virtual reality change the landscape of education?\"" >> phrases.txt
echo -e "\"What are the challenges of cybersecurity in the era of IoT?\"" >> phrases.txt
echo -e "\"How does renewable energy contribute to sustainable development?\"" >> phrases.txt
echo -e "\"What are the implications of 5G technology on global communication?\"" >> phrases.txt
echo -e "\"How can data analytics enhance decision-making in businesses?\"" >> phrases.txt
echo -e "\"What are the future trends in wearable technology?\"" >> phrases.txt
echo -e "\"How does biotechnology influence modern agriculture?\"" >> phrases.txt
echo -e "\"What are the key factors in developing smart cities?\"" >> phrases.txt
echo -e "\"How does machine learning optimize healthcare services?\"" >> phrases.txt
echo -e "\"What are the environmental impacts of cryptocurrency mining?\"" >> phrases.txt
echo -e "\"How does augmented reality transform the retail industry?\"" >> phrases.txt
echo -e "\"What are the benefits of telecommuting for companies and employees?\"" >> phrases.txt
echo -e "\"How does nanotechnology revolutionize material science?\"" >> phrases.txt
echo -e "\"What are the social implications of social media algorithms?\"" >> phrases.txt
echo -e "\"How does space exploration contribute to technological innovation?\"" >> phrases.txt
echo -e "\"What are the challenges in implementing universal basic income?\"" >> phrases.txt
echo -e "\"How does the gig economy affect traditional employment models?\"" >> phrases.txt
echo -e "\"What are the potential impacts of AI on creative industries?\"" >> phrases.txt
echo -e "\"How does digital currency influence global financial systems?\"" >> phrases.txt
echo -e "\"What are the strategies for achieving carbon neutrality?\"" >> phrases.txt
echo -e "\"How does the internet of things enhance home automation?\"" >> phrases.txt
echo -e "\"What are the ethical dilemmas of surveillance technologies?\"" >> phrases.txt
echo -e "\"How does biotechnology address global health challenges?\"" >> phrases.txt
echo -e "\"What are the innovations in sustainable packaging solutions?\"" >> phrases.txt
echo -e "\"How does quantum cryptography ensure data security?\"" >> phrases.txt
echo -e "\"What are the future prospects of electric aviation?\"" >> phrases.txt
echo -e "\"How does artificial intelligence improve disaster response?\"" >> phrases.txt
echo -e "\"What are the implications of genetic data privacy?\"" >> phrases.txt
echo -e "\"How does 3D printing impact manufacturing industries?\"" >> phrases.txt
echo -e "\"What are the advancements in personalized medicine?\"" >> phrases.txt
echo -e "\"How does cloud computing support remote work environments?\"" >> phrases.txt
echo -e "\"What are the challenges of implementing smart grid technology?\"" >> phrases.txt
echo -e "\"How does digital transformation affect public sector services?\"" >> phrases.txt
echo -e "\"What are the latest trends in artificial intelligence research?\"" >> phrases.txt
echo -e "\"How does the integration of AI in healthcare improve patient outcomes?\"" >> phrases.txt
echo -e "\"What are the potential impacts of quantum computing on cybersecurity?\"" >> phrases.txt
echo -e "\"How does the development of smart cities affect urban living?\"" >> phrases.txt
echo -e "\"What are the challenges and opportunities of space tourism?\"" >> phrases.txt
echo -e "\"How does the rise of e-commerce influence traditional retail?\"" >> phrases.txt
echo -e "\"What are the environmental benefits of electric vehicles?\"" >> phrases.txt
echo -e "\"How does the use of big data analytics transform business strategies?\"" >> phrases.txt
echo -e "\"What are the ethical concerns surrounding AI in surveillance?\"" >> phrases.txt
echo -e "\"How does the integration of renewable energy sources affect the power grid?\"" >> phrases.txt
echo -e "\"What are the potential applications of CRISPR technology in medicine?\"" >> phrases.txt
echo -e "\"How does the sharing economy reshape consumer behavior?\"" >> phrases.txt
echo -e "\"What are the impacts of digital twins on industrial processes?\"" >> phrases.txt
echo -e "\"How does AI-driven automation influence job markets?\"" >> phrases.txt
echo -e "\"What are the challenges of ensuring data privacy in smart devices?\"" >> phrases.txt
echo -e "\"How does the evolution of 6G technology promise to change connectivity?\"" >> phrases.txt
echo -e "\"What are the implications of AI in personalized marketing?\"" >> phrases.txt
echo -e "\"How does the advancement of robotics impact manufacturing efficiency?\"" >> phrases.txt
echo -e "\"What are the future possibilities of human-machine collaboration?\"" >> phrases.txt
echo -e "\"How does the development of autonomous drones affect logistics?\"" >> phrases.txt
echo -e "\"What are the ethical considerations of AI in decision-making processes?\"" >> phrases.txt
echo -e "\"How does the rise of digital currencies challenge traditional banking?\"" >> phrases.txt
echo -e "\"What are the potential benefits of AI in environmental conservation?\"" >> phrases.txt
echo -e "\"How does the integration of AI in education enhance learning experiences?\"" >> phrases.txt
echo -e "\"What are the challenges of regulating AI technologies globally?\"" >> phrases.txt
echo -e "\"How does the use of AI in agriculture improve crop yields?\"" >> phrases.txt
echo -e "\"What are the implications of AI in autonomous military systems?\"" >> phrases.txt
echo -e "\"How does the development of AI in healthcare revolutionize diagnostics?\"" >> phrases.txt
echo -e "\"What are the potential impacts of AI on global economic structures?\"" >> phrases.txt
echo -e "\"How does the integration of AI in transportation improve safety?\"" >> phrases.txt
echo -e "\"What are the challenges of AI in maintaining cybersecurity?\"" >> phrases.txt
echo -e "\"How does AI contribute to advancements in space exploration?\"" >> phrases.txt
echo -e "\"What are the ethical implications of AI in genetic engineering?\"" >> phrases.txt
echo -e "\"How does AI influence the future of personalized medicine?\"" >> phrases.txt
echo -e "\"What are the potential impacts of AI on global trade dynamics?\"" >> phrases.txt
echo -e "\"How does AI enhance the capabilities of smart home devices?\"" >> phrases.txt
echo -e "\"What are the challenges of integrating AI in public transportation systems?\"" >> phrases.txt
echo -e "\"How does AI-driven innovation affect the future of work?\"" >> phrases.txt
echo -e "\"What are the implications of AI in the development of smart cities?\"" >> phrases.txt
echo -e "\"How does AI impact the evolution of digital entertainment?\"" >> phrases.txt
echo -e "\"What are the potential benefits of AI in disaster management?\"" >> phrases.txt
echo -e "\"How does AI influence the design of future urban landscapes?\"" >> phrases.txt
echo -e "\"What are the challenges of AI in maintaining ethical standards?\"" >> phrases.txt
echo -e "\"How does AI contribute to the advancement of renewable energy technologies?\"" >> phrases.txt
echo -e "\"What are the implications of AI in the future of healthcare delivery?\"" >> phrases.txt
echo -e "\"How does AI impact the development of next-generation communication networks?\"" >> phrases.txt
echo -e "\"What are the potential impacts of AI on global environmental policies?\"" >> phrases.txt
echo -e "\"How does AI enhance the efficiency of supply chain management?\"" >> phrases.txt
echo -e "\"What are the challenges of AI in ensuring data integrity?\"" >> phrases.txt
echo -e "\"How does AI influence the future of personalized customer experiences?\"" >> phrases.txt
echo -e "\"What are the implications of AI in the evolution of digital currencies?\"" >> phrases.txt
echo -e "\"How does AI contribute to the development of sustainable urban environments?\"" >> phrases.txt
echo -e "\"What are the potential benefits of AI in enhancing public safety?\"" >> phrases.txt
echo -e "\"How does AI impact the future of global economic competitiveness?\"" >> phrases.txt
echo -e "\"What are the challenges of AI in maintaining transparency and accountability?\"" >> phrases.txt
echo -e "\"How does AI influence the design of future healthcare systems?\"" >> phrases.txt
echo -e "\"What are the implications of AI in the development of autonomous vehicles?\"" >> phrases.txt
echo -e "\"How does AI enhance the capabilities of next-generation robotics?\"" >> phrases.txt
echo -e "\"What are the potential impacts of AI on global security frameworks?\"" >> phrases.txt
echo -e "\"How does AI contribute to the advancement of digital communication technologies?\"" >> phrases.txt
echo -e "\"What are the challenges of AI in ensuring ethical decision-making?\"" >> phrases.txt
echo -e "\"How does AI influence the future of personalized healthcare solutions?\"" >> phrases.txt
echo -e "\"What are the implications of AI in the evolution of smart infrastructure?\"" >> phrases.txt
echo -e "\"How does AI impact the development of future educational models?\"" >> phrases.txt
echo -e "\"What are the potential benefits of AI in enhancing global collaboration?\"" >> phrases.txt
echo -e "\"How does AI influence the design of future transportation systems?\"" >> phrases.txt
echo -e "\"What are the challenges of AI in maintaining privacy and security?\"" >> phrases.txt
echo -e "\"How does AI contribute to the advancement of digital healthcare technologies?\"" >> phrases.txt
echo -e "\"What are the implications of AI in the future of global trade?\"" >> phrases.txt
echo -e "\"How does AI enhance the capabilities of future communication networks?\"" >> phrases.txt
echo -e "\"What are the potential impacts of AI on global economic growth?\"" >> phrases.txt
echo -e "\"How does AI influence the future of personalized learning experiences?\"" >> phrases.txt
echo -e "\"What are the challenges of AI in ensuring ethical governance?\"" >> phrases.txt
echo -e "\"How does AI contribute to the development of sustainable energy solutions?\"" >> phrases.txt
echo -e "\"What are the implications of AI in the evolution of digital ecosystems?\"" >> phrases.txt
echo -e "\"How does AI impact the future of global economic stability?\"" >> phrases.txt
echo -e "\"What are the potential benefits of AI in enhancing digital security?\"" >> phrases.txt
echo -e "\"How does AI influence the design of future smart city infrastructures?\"" >> phrases.txt
echo -e "\"What are the challenges of AI in maintaining ethical standards in technology?\"" >> phrases.txt
echo -e "\"How does AI contribute to the advancement of global healthcare systems?\"" >> phrases.txt
echo -e "\"What are the implications of AI in the future of digital innovation?\"" >> phrases.txt
echo -e "\"How does AI enhance the capabilities of future digital platforms?\"" >> phrases.txt
echo -e "\"What are the potential impacts of AI on global technological advancements?\"" >> phrases.txt
echo -e "\"How does AI influence the future of personalized digital experiences?\"" >> phrases.txt
echo -e "\"What are the challenges of AI in ensuring ethical use of technology?\"" >> phrases.txt
echo -e "\"How does AI contribute to the development of future digital ecosystems?\"" >> phrases.txt
echo -e "\"What are the implications of AI in the evolution of global digital landscapes?\"" >> phrases.txt
echo -e "\"How does AI impact the future of global digital connectivity?\"" >> phrases.txt
echo -e "\"What are the potential benefits of AI in enhancing digital collaboration?\"" >> phrases.txt
echo -e "\"How does AI influence the design of future digital infrastructures?\"" >> phrases.txt
echo -e "\"What are the challenges of AI in maintaining ethical standards in digital innovation?\"" >> phrases.txt
echo -e "\"How does AI contribute to the advancement of global digital ecosystems?\"" >> phrases.txt
echo -e "\"What are the implications of AI in the future of digital transformation?\"" >> phrases.txt
echo -e "\"How does AI enhance the capabilities of future digital technologies?\"" >> phrases.txt
echo -e "\"What are the potential impacts of AI on global digital development?\"" >> phrases.txt
echo -e "\"How does AI influence the future of personalized digital solutions?\"" >> phrases.txt
echo -e "\"What are the challenges of AI in ensuring ethical digital practices?\"" >> phrases.txt
echo -e "\"How does AI contribute to the development of future digital innovations?\"" >> phrases.txt
echo -e "\"What are the implications of AI in the evolution of global digital strategies?\"" >> phrases.txt
echo -e "\"How does AI impact the future of global digital economies?\"" >> phrases.txt
echo -e "\"What are the potential benefits of AI in enhancing digital innovation?\"" >> phrases.txt
echo -e "\"How does AI influence the design of future digital solutions?\"" >> phrases.txt
echo -e "\"What are the challenges of AI in maintaining ethical standards in digital solutions?\"" >> phrases.txt
echo -e "\"How does AI contribute to the advancement of global digital solutions?\"" >> phrases.txt
echo -e "\"What are the implications of AI in the future of digital solutions?\"" >> phrases.txt
echo -e "\"How does AI enhance the capabilities of future digital solutions?\"" >> phrases.txt
echo -e "\"What are the potential impacts of AI on global digital solutions?\"" >> phrases.txt
echo -e "\"How does AI influence the future of personalized digital solutions?\"" >> phrases.txt
echo -e "\"What are the challenges of AI in ensuring ethical digital solutions?\"" >> phrases.txt
echo -e "\"How does AI contribute to the development of future digital solutions?\"" >> phrases.txt
echo -e "\"What are the implications of AI in the evolution of global digital solutions?\"" >> phrases.txt
echo -e "\"How does AI impact the future of global digital solutions?\"" >> phrases.txt
echo -e "\"What are the potential benefits of AI in enhancing digital solutions?\"" >> phrases.txt
echo -e "\"How does AI influence the design of future digital solutions?\"" >> phrases.txt
echo -e "\"What are the challenges of AI in maintaining ethical standards in digital solutions?\"" >> phrases.txt
echo -e "\"How does AI contribute to the advancement of global digital solutions?\"" >> phrases.txt
        
# Добавление ролей в roles.txt
echo -e "system\nuser\nassistant\ntool" > roles.txt

echo -e "${YELLOW}📥 Загрузка скрипта бота...${NC}"
curl -L https://raw.githubusercontent.com/NodEligible/guides/main/gaianet/gaia_bot.py -o gaia_bot.py

echo -e "${YELLOW}⚙️  Настройка бота...${NC}"
echo -e "${YELLOW}🔑 Введите адрес вашей ноды:${NC}"
read -p "➜ " NODE_ID
        
sed -i "s|\$NODE_ID|$NODE_ID|g" gaia_bot.py

USERNAME=$(whoami)
HOME_DIR=$(eval echo ~$USERNAME)

echo -e "${YELLOW}🚀 Настройка и запуск сервиса...${NC}"
# Сервис для запуска бота
echo -e "[Unit]
Description=Gaia Bot
After=network.target

[Service]
Environment=NODE_ID=$NODE_ID
Environment=RETRY_COUNT=3
Environment=RETRY_DELAY=5
Environment=TIMEOUT=60
ExecStart=/usr/bin/python3 $HOME_DIR/gaia-bot/gaia_bot.py
Restart=always
User=$USERNAME
Group=$USERNAME
WorkingDirectory=$HOME_DIR/gaia-bot

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/gaia-bot.service

        # Запуск бота
sudo systemctl daemon-reload
sleep 1
sudo systemctl enable gaia-bot.service
sudo systemctl start gaia-bot.service

echo -e "${GREEN}✅ Бот успешно запущен!${NC}"
echo -e "📋 Для просмотра логов используйте команду:"
echo -e "sudo journalctl -u gaia-bot -f"


