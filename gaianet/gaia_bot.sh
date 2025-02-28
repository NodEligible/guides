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
echo -e "\"What are the latest advancements in quantum computing?\"" > phrases.txt
echo -e "\"How does artificial intelligence impact climate change solutions?\"" >> phrases.txt
echo -e "\"What are the ethical considerations of gene editing technologies?\"" >> phrases.txt
echo -e "\"How can blockchain technology improve supply chain transparency?\"" >> phrases.txt
echo -e "\"What are the potential benefits and risks of autonomous vehicles?\"" >> phrases.txt
echo -e "\"How does virtual reality change the landscape of education?\"" >> phrases.txt
echo -e "\"What role does AI play in cybersecurity?\"" >> phrases.txt
echo -e "\"What are the latest breakthroughs in space travel?\"" >> phrases.txt
echo -e "\"How do quantum computers differ from classical computers?\"" >> phrases.txt
echo -e "\"What are the potential risks of artificial intelligence?\"" >> phrases.txt
echo -e "\"How does genetic engineering impact modern medicine?\"" >> phrases.txt
echo -e "\"What are the future trends in autonomous robotics?\"" >> phrases.txt
echo -e "\"How can IoT improve urban infrastructure?\"" >> phrases.txt
echo -e "\"What are the benefits and drawbacks of nuclear energy?\"" >> phrases.txt
echo -e "\"How does machine learning enhance financial fraud detection?\"" >> phrases.txt
echo -e "\"What are the latest advancements in drone technology?\"" >> phrases.txt
echo -e "\"How does AI contribute to personalized learning?\"" >> phrases.txt
echo -e "\"What are the challenges of deep-sea exploration?\"" >> phrases.txt
echo -e "\"How can smart contracts improve business efficiency?\"" >> phrases.txt
echo -e "\"What are the ethical concerns of AI-generated content?\"" >> phrases.txt
echo -e "\"How does space mining impact Earth's economy?\"" >> phrases.txt
echo -e "\"What are the future applications of nanotechnology?\"" >> phrases.txt
echo -e "\"How does blockchain enhance digital identity verification?\"" >> phrases.txt
echo -e "\"What is the role of AI in disaster response management?\"" >> phrases.txt
echo -e "\"How does 3D printing impact industrial manufacturing?\"" >> phrases.txt
echo -e "\"What are the implications of brain-computer interfaces?\"" >> phrases.txt
echo -e "\"How does the metaverse shape online interactions?\"" >> phrases.txt
echo -e "\"What are the consequences of mass surveillance technology?\"" >> phrases.txt
echo -e "\"How does AI-powered automation affect employment?\"" >> phrases.txt
echo -e "\"What are the cybersecurity risks of smart cities?\"" >> phrases.txt
echo -e "\"How does biotechnology revolutionize pharmaceuticals?\"" >> phrases.txt
echo -e "\"What are the key components of a sustainable economy?\"" >> phrases.txt
echo -e "\"How does AI help in wildlife conservation?\"" >> phrases.txt
echo -e "\"What are the benefits of decentralized finance (DeFi)?\"" >> phrases.txt
echo -e "\"How does AI assist in autonomous driving?\"" >> phrases.txt
echo -e "\"What are the challenges in achieving nuclear fusion energy?\"" >> phrases.txt
echo -e "\"How does AI-driven drug discovery work?\"" >> phrases.txt
echo -e "\"What are the future prospects of flying cars?\"" >> phrases.txt
echo -e "\"How can technology mitigate climate change?\"" >> phrases.txt
echo -e "\"What are the security risks of quantum computing?\"" >> phrases.txt
echo -e "\"How does AI-powered facial recognition impact privacy?\"" >> phrases.txt
echo -e "\"What are the advancements in wearable medical devices?\"" >> phrases.txt
echo -e "\"How does robotics improve elderly care?\"" >> phrases.txt
echo -e "\"What are the implications of AI in military applications?\"" >> phrases.txt
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
echo -e "\"What are the key ethical concerns in AI development?\"" >> phrases.txt
echo -e "\"How can AI be leveraged for mental health therapy?\"" >> phrases.txt
echo -e "\"What are the risks and benefits of AI in predictive policing?\"" >> phrases.txt
echo -e "\"How does AI impact the gig economy and freelancing?\"" >> phrases.txt
echo -e "\"What are the latest developments in renewable energy storage solutions?\"" >> phrases.txt
echo -e "\"How does artificial intelligence contribute to climate modeling accuracy?\"" >> phrases.txt
echo -e "\"What are the social implications of widespread AI-generated content?\"" >> phrases.txt
echo -e "\"How does genetic modification impact global food security?\"" >> phrases.txt
echo -e "\"What are the ethical concerns of AI in automated hiring processes?\"" >> phrases.txt
echo -e "\"How can smart cities leverage big data for urban planning?\"" >> phrases.txt
echo -e "\"What are the implications of AI-driven legal decision-making?\"" >> phrases.txt
echo -e "\"How does cryptocurrency adoption influence traditional banking systems?\"" >> phrases.txt
echo -e "\"What are the future challenges of quantum encryption?\"" >> phrases.txt
echo -e "\"How can AI-powered tools improve accessibility for disabled individuals?\"" >> phrases.txt
echo -e "\"What are the environmental effects of mass production in the fashion industry?\"" >> phrases.txt
echo -e "\"How does personalized medicine change the pharmaceutical industry?\"" >> phrases.txt
echo -e "\"What are the risks and benefits of AI-driven medical diagnoses?\"" >> phrases.txt
echo -e "\"How does the gig economy influence social security structures?\"" >> phrases.txt
echo -e "\"What are the long-term effects of social media on mental health?\"" >> phrases.txt
echo -e "\"How does AI influence modern journalism and fact-checking?\"" >> phrases.txt
echo -e "\"What are the security concerns of widespread biometric authentication?\"" >> phrases.txt
echo -e "\"How does AI help detect and combat cyber threats?\"" >> phrases.txt
echo -e "\"What are the economic impacts of the shift to electric vehicles?\"" >> phrases.txt
echo -e "\"How does automation affect employment in traditional industries?\"" >> phrases.txt
echo -e "\"What are the challenges of integrating AI in public healthcare systems?\"" >> phrases.txt
echo -e "\"How can AI-driven chatbots improve customer service?\"" >> phrases.txt
echo -e "\"What are the benefits and challenges of fully autonomous ships?\"" >> phrases.txt
echo -e "\"How does AI contribute to real-time language translation?\"" >> phrases.txt
echo -e "\"What are the implications of AI in high-frequency trading?\"" >> phrases.txt
echo -e "\"How does blockchain technology enhance intellectual property protection?\"" >> phrases.txt
echo -e "\"What are the social risks of deepfake technology?\"" >> phrases.txt
echo -e "\"How does AI-driven music composition impact the entertainment industry?\"" >> phrases.txt
echo -e "\"What are the potential uses of AI in archaeological research?\"" >> phrases.txt
echo -e "\"How does AI influence predictive maintenance in industrial applications?\"" >> phrases.txt
echo -e "\"What are the challenges in regulating autonomous weapon systems?\"" >> phrases.txt
echo -e "\"How does AI help optimize supply chain logistics?\"" >> phrases.txt
echo -e "\"What are the privacy concerns surrounding smart home devices?\"" >> phrases.txt
echo -e "\"How does AI-driven drug development accelerate clinical trials?\"" >> phrases.txt
echo -e "\"What are the risks of AI-generated misinformation?\"" >> phrases.txt
echo -e "\"How can AI be used to combat climate change?\"" >> phrases.txt
echo -e "\"What are the potential risks and rewards of AI-powered financial advisors?\"" >> phrases.txt
echo -e "\"What are the biggest challenges of establishing a human colony on Mars?\"" >> phrases.txt
echo -e "\"How does space debris impact future space exploration missions?\"" >> phrases.txt
echo -e "\"What are the potential benefits of mining asteroids for rare minerals?\"" >> phrases.txt
echo -e "\"How do black holes influence the structure of galaxies?\"" >> phrases.txt
echo -e "\"What are the technological advancements needed for interstellar travel?\"" >> phrases.txt
echo -e "\"How does microgravity affect human biology over long space missions?\"" >> phrases.txt
echo -e "\"What are the implications of discovering extraterrestrial life?\"" >> phrases.txt
echo -e "\"How does dark matter shape our understanding of the universe?\"" >> phrases.txt
echo -e "\"What are the latest discoveries about exoplanets and their potential habitability?\"" >> phrases.txt
echo -e "\"How does quantum physics influence our theories of the cosmos?\"" >> phrases.txt
echo -e "\"What are the effects of solar radiation on spacecraft electronics?\"" >> phrases.txt
echo -e "\"How do neutron stars differ from black holes?\"" >> phrases.txt
echo -e "\"What are the latest advancements in space propulsion technology?\"" >> phrases.txt
echo -e "\"How can AI improve space mission planning and execution?\"" >> phrases.txt
echo -e "\"What are the challenges of growing food in space?\"" >> phrases.txt
echo -e "\"How do cosmic rays affect astronauts on deep space missions?\"" >> phrases.txt
echo -e "\"What are the latest discoveries about the Kuiper Belt?\"" >> phrases.txt
echo -e "\"How do gravitational waves help us understand the universe?\"" >> phrases.txt
echo -e "\"What are the potential dangers of gamma-ray bursts?\"" >> phrases.txt
echo -e "\"How do we detect rogue planets in interstellar space?\"" >> phrases.txt
echo -e "\"What are the possibilities of terraforming Mars?\"" >> phrases.txt
echo -e "\"How does the Sun’s activity impact space weather?\"" >> phrases.txt
echo -e "\"What are the biggest threats to satellites in Earth's orbit?\"" >> phrases.txt
echo -e "\"How can 3D printing be used for building structures on the Moon?\"" >> phrases.txt
echo -e "\"What are the most promising locations for life in our solar system?\"" >> phrases.txt
echo -e "\"How do scientists measure the age of the universe?\"" >> phrases.txt
echo -e "\"What role does antimatter play in modern physics?\"" >> phrases.txt
echo -e "\"How can space elevators revolutionize space travel?\"" >> phrases.txt
echo -e "\"What are the potential applications of lunar helium-3 as a fuel source?\"" >> phrases.txt
echo -e "\"How do radio telescopes help us understand distant galaxies?\"" >> phrases.txt
echo -e "\"What are the benefits of international collaboration in space exploration?\"" >> phrases.txt
echo -e "\"How does the expansion of the universe affect the fate of galaxies?\"" >> phrases.txt
echo -e "\"What are the main obstacles to faster-than-light travel?\"" >> phrases.txt
echo -e "\"How do space agencies plan for long-duration missions to the outer planets?\"" >> phrases.txt
echo -e "\"What are the future prospects of asteroid deflection technology?\"" >> phrases.txt
echo -e "\"How do planetary magnetic fields protect atmospheres from solar wind?\"" >> phrases.txt
echo -e "\"What is the significance of the Oort Cloud in our solar system?\"" >> phrases.txt
echo -e "\"How do exoplanet atmospheres help us search for alien life?\"" >> phrases.txt
echo -e "\"What are the potential risks of sending messages to extraterrestrial civilizations?\"" >> phrases.txt
echo -e "\"How does zero gravity impact human muscle and bone density?\"" >> phrases.txt
echo -e "\"What are the technological challenges of building habitats on Mars?\"" >> phrases.txt
echo -e "\"How do we search for water on distant exoplanets?\"" >> phrases.txt
echo -e "\"What is the role of dark energy in the expansion of the universe?\"" >> phrases.txt
echo -e "\"How do we protect astronauts from cosmic radiation on long-duration missions?\"" >> phrases.txt
echo -e "\"What are the latest developments in plasma propulsion for deep space travel?\"" >> phrases.txt
echo -e "\"How can nuclear fusion be used for space exploration?\"" >> phrases.txt
echo -e "\"What are the key differences between brown dwarfs and gas giants?\"" >> phrases.txt
echo -e "\"How do we study the atmospheres of exoplanets?\"" >> phrases.txt
echo -e "\"What are the possible effects of space weather on Earth’s power grids?\"" >> phrases.txt
echo -e "\"How does space tourism impact the environment and space industry?\"" >> phrases.txt
echo -e "\"What are the ethical implications of space colonization?\"" >> phrases.txt
echo -e "\"How do tidal forces affect celestial bodies in close orbits?\"" >> phrases.txt
echo -e "\"What are the most extreme weather conditions on other planets?\"" >> phrases.txt
echo -e "\"How do we map the large-scale structure of the universe?\"" >> phrases.txt
echo -e "\"What are the prospects of finding habitable moons in other star systems?\"" >> phrases.txt
echo -e "\"How can AI improve space debris tracking and removal?\"" >> phrases.txt
echo -e "\"What is the significance of the James Webb Space Telescope’s discoveries?\"" >> phrases.txt
echo -e "\"What are the effects of deforestation on biodiversity?\"" >> phrases.txt
echo -e "\"How do rainforest ecosystems maintain global oxygen levels?\"" >> phrases.txt
echo -e "\"What are the latest advancements in rainforest conservation?\"" >> phrases.txt
echo -e "\"How can AI improve wildlife tracking and monitoring?\"" >> phrases.txt
echo -e "\"What are the challenges of reintroducing species into the wild?\"" >> phrases.txt
echo -e "\"How do natural forest fires benefit ecosystems?\"" >> phrases.txt
echo -e "\"What are the latest discoveries about the Amazon rainforest?\"" >> phrases.txt
echo -e "\"How do mangroves protect coastal regions from storms?\"" >> phrases.txt
echo -e "\"What are the potential dangers of habitat fragmentation?\"" >> phrases.txt
echo -e "\"How do pollinators contribute to ecosystem stability?\"" >> phrases.txt
echo -e "\"What are the possibilities of restoring degraded forests?\"" >> phrases.txt
echo -e "\"How does climate change impact the water cycle in rainforests?\"" >> phrases.txt
echo -e "\"What are the biggest threats to endangered species in the jungle?\"" >> phrases.txt
echo -e "\"How can sustainable agriculture reduce deforestation?\"" >> phrases.txt
echo -e "\"What are the most effective methods for reforestation?\"" >> phrases.txt
echo -e "\"How do indigenous communities contribute to forest conservation?\"" >> phrases.txt
echo -e "\"What role do fungi play in rainforest ecosystems?\"" >> phrases.txt
echo -e "\"How do river systems support jungle biodiversity?\"" >> phrases.txt
echo -e "\"What are the benefits of ecotourism in tropical forests?\"" >> phrases.txt
echo -e "\"How does the Amazon River influence the global climate?\"" >> phrases.txt
echo -e "\"What are the main obstacles to stopping illegal logging?\"" >> phrases.txt
echo -e "\"How does rewilding help restore lost ecosystems?\"" >> phrases.txt
echo -e "\"What are the future prospects of protecting rainforests?\"" >> phrases.txt
echo -e "\"How do tropical forests act as carbon sinks?\"" >> phrases.txt
echo -e "\"What is the significance of biodiversity hotspots?\"" >> phrases.txt
echo -e "\"How do tree canopies create unique microhabitats?\"" >> phrases.txt
echo -e "\"What are the best ways to combat poaching in rainforests?\"" >> phrases.txt
echo -e "\"How does deforestation affect indigenous cultures?\"" >> phrases.txt
echo -e "\"What are the potential medicinal properties of jungle plants?\"" >> phrases.txt
echo -e "\"How do conservationists track large predators in the wild?\"" >> phrases.txt
echo -e "\"What are the effects of invasive species on rainforest ecosystems?\"" >> phrases.txt
echo -e "\"How do seasonal monsoons impact tropical forests?\"" >> phrases.txt
echo -e "\"What are the key adaptations of animals living in dense jungles?\"" >> phrases.txt
echo -e "\"How can urban reforestation efforts improve local biodiversity?\"" >> phrases.txt
echo -e "\"What are the impacts of palm oil plantations on wildlife?\"" >> phrases.txt
echo -e "\"How does deforestation contribute to global warming?\"" >> phrases.txt
echo -e "\"What are the most endangered species of the rainforest?\"" >> phrases.txt
echo -e "\"How do rivers and wetlands sustain jungle biodiversity?\"" >> phrases.txt
echo -e "\"What are the effects of pesticide use in tropical forests?\"" >> phrases.txt
echo -e "\"How do trees communicate through fungal networks?\"" >> phrases.txt
echo -e "\"What role do keystone species play in rainforest stability?\"" >> phrases.txt
echo -e "\"How can conservation technology improve jungle preservation?\"" >> phrases.txt
echo -e "\"What are the best strategies for preventing illegal wildlife trade?\"" >> phrases.txt
echo -e "\"How do rainforests regulate the Earth's water cycle?\"" >> phrases.txt
echo -e "\"What are the long-term effects of habitat loss on ecosystems?\"" >> phrases.txt
echo -e "\"How can tree planting initiatives help restore biodiversity?\"" >> phrases.txt
echo -e "\"What are the consequences of mining in tropical regions?\"" >> phrases.txt
echo -e "\"How do forest elephants shape their environment?\"" >> phrases.txt
echo -e "\"What are the advantages of protecting primary forests?\"" >> phrases.txt
echo -e "\"How do amphibians adapt to the humid rainforest climate?\"" >> phrases.txt
echo -e "\"What are the benefits of integrating agroforestry into farming?\"" >> phrases.txt
echo -e "\"How does reforestation support endangered species recovery?\"" >> phrases.txt

        
# Добавление ролей в roles.txt
echo -e "system\nuser\nassistant\ntool" > roles.txt

echo -e "${YELLOW}📥 Загрузка скрипта бота...${NC}"
curl -L https://raw.githubusercontent.com/NodEligible/guides/main/gaianet/gaia_bot.py -o gaia_bot.py

echo -e "${YELLOW}⚙️  Настройка бота...${NC}"
echo -e "${YELLOW}🔑 Вставьте NODE_ID вашей ноды :${NC}"
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


