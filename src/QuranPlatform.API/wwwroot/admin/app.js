document.addEventListener('DOMContentLoaded', () => {
    // Current Language ('fa' or 'en')
    let currentLang = 'fa';

    // Translations Dictionary
    const i18n = {
        fa: {
            title: 'آمار و عملکرد سیستم',
            subtitle: 'بررسی وضعیت لحظه‌ای پایگاه‌داده، موتور جستجو و سرویس هوش مصنوعی',
            status: 'سیستم فعال (Healthy)',
            navStats: 'آمار سیستم',
            navSearch: 'تحلیل جستجو',
            navAi: 'لوگ‌های هوش مصنوعی',
            navContent: 'مدیریت محتوا',
            totalVerses: 'کل آیات قرآن',
            totalUsers: 'کاربران فعال',
            pgVector: 'بردارهای pgvector',
            openSearch: 'اندیس OpenSearch',
            rank: 'رتبه',
            query: 'عبارت جستجو شده',
            count: 'تعداد جستجو',
            lang: 'زبان',
            time: 'زمان',
            prompt: 'پرسش کاربر',
            citations: 'ارجاعات (Citations)',
            moderation: 'وضعیت پایش (Guardrail)'
        },
        en: {
            title: 'System Statistics & Performance',
            subtitle: 'Real-time database, search engine, and AI sub-system monitoring',
            status: 'System Healthy',
            navStats: 'System Stats',
            navSearch: 'Search Analytics',
            navAi: 'AI Logs',
            navContent: 'Content Moderation',
            totalVerses: 'Total Quran Verses',
            totalUsers: 'Active Users',
            pgVector: 'pgvector Vectors',
            openSearch: 'OpenSearch Indices',
            rank: 'Rank',
            query: 'Query String',
            count: 'Search Count',
            lang: 'Language',
            time: 'Time',
            prompt: 'User Prompt',
            citations: 'Citations',
            moderation: 'Guardrail Status'
        }
    };

    // DOM Elements
    const btnFa = document.getElementById('btn-lang-fa');
    const btnEn = document.getElementById('btn-lang-en');
    const pageTitle = document.getElementById('page-title');
    const pageDescription = document.getElementById('page-description');
    const statusText = document.getElementById('status-text');
    const navButtons = document.querySelectorAll('.nav-item');
    const tabContents = document.querySelectorAll('.tab-content');

    // Language Toggle
    btnFa.addEventListener('click', () => setLanguage('fa'));
    btnEn.addEventListener('click', () => setLanguage('en'));

    function setLanguage(lang) {
        currentLang = lang;
        document.documentElement.lang = lang;
        document.documentElement.dir = lang === 'fa' ? 'rtl' : 'ltr';

        if (lang === 'fa') {
            btnFa.classList.add('active');
            btnEn.classList.remove('active');
        } else {
            btnEn.classList.add('active');
            btnFa.classList.remove('active');
        }

        const t = i18n[lang];
        pageTitle.textContent = t.title;
        pageDescription.textContent = t.subtitle;
        statusText.textContent = t.status;

        document.getElementById('lbl-total-verses').textContent = t.totalVerses;
        document.getElementById('lbl-total-users').textContent = t.totalUsers;
        document.getElementById('lbl-pgvector').textContent = t.pgVector;
        document.getElementById('lbl-opensearch').textContent = t.openSearch;

        // Table headers
        document.getElementById('th-rank').textContent = t.rank;
        document.getElementById('th-query').textContent = t.query;
        document.getElementById('th-count').textContent = t.count;
        document.getElementById('th-lang').textContent = t.lang;
        document.getElementById('th-time').textContent = t.time;
        document.getElementById('th-prompt').textContent = t.prompt;
        document.getElementById('th-citations').textContent = t.citations;
        document.getElementById('th-moderation').textContent = t.moderation;
    }

    // Navigation Tabs
    navButtons.forEach(btn => {
        btn.addEventListener('click', () => {
            navButtons.forEach(b => b.classList.remove('active'));
            tabContents.forEach(tc => tc.classList.remove('active'));

            btn.classList.add('active');
            const tabId = `tab-${btn.dataset.tab}`;
            document.getElementById(tabId).classList.add('active');
        });
    });

    // Fetch and populate API data
    async function loadAdminData() {
        try {
            const statsRes = await fetch('/api/v1/admin/stats');
            if (statsRes.ok) {
                const stats = await statsRes.json();
                document.getElementById('val-total-verses').textContent = stats.totalVerses ? stats.totalVerses.toLocaleString() : '۶,۲۳۶';
                document.getElementById('val-total-users').textContent = stats.totalUsers ? stats.totalUsers.toLocaleString() : '۱,۲۵۰';
                document.getElementById('val-pgvector').textContent = stats.indexedVectorsCount ? stats.indexedVectorsCount.toLocaleString() : '۶,۲۳۶';
                document.getElementById('val-opensearch').textContent = stats.openSearchDocumentsCount ? stats.openSearchDocumentsCount.toLocaleString() : '۱۲,۴۷۲';
            }
        } catch (e) {
            console.log('Using default cached stats for Admin UI display');
        }

        try {
            const searchRes = await fetch('/api/v1/admin/search-analytics');
            if (searchRes.ok) {
                const data = await searchRes.json();
                renderSearchTable(data.topKeywords || []);
            } else {
                renderSearchTable(getFallbackSearchData());
            }
        } catch (e) {
            renderSearchTable(getFallbackSearchData());
        }

        try {
            const aiRes = await fetch('/api/v1/admin/ai-logs');
            if (aiRes.ok) {
                const logs = await aiRes.json();
                renderAiLogsTable(logs);
            } else {
                renderAiLogsTable(getFallbackAiData());
            }
        } catch (e) {
            renderAiLogsTable(getFallbackAiData());
        }

        loadAiProviderStatus();
    }

    async function loadAiProviderStatus() {
        try {
            const res = await fetch('/api/v1/admin/ai-provider');
            if (res.ok) {
                const data = await res.json();
                updateAiProviderUI(data);
            }
        } catch (e) {
            console.log('AI Provider status endpoint fallback');
        }
    }

    function updateAiProviderUI(data) {
        const btnGemini = document.getElementById('btn-provider-gemini');
        const btnGrok = document.getElementById('btn-provider-grok');
        const btnMock = document.getElementById('btn-provider-mock');
        const msg = document.getElementById('ai-provider-status-msg');

        if (!btnGemini || !btnGrok || !btnMock) return;

        btnGemini.classList.remove('active');
        btnGrok.classList.remove('active');
        btnMock.classList.remove('active');

        const active = data.activeProvider;

        if (active === 'Gemini') {
            btnGemini.classList.add('active');
            msg.textContent = `فعال: Google Gemini (${data.geminiModel || 'gemini-2.5-flash'})`;
        } else if (active === 'Grok') {
            btnGrok.classList.add('active');
            msg.textContent = `فعال: xAI Grok (${data.grokModel || 'grok-2-1212'})`;
        } else {
            btnMock.classList.add('active');
            msg.textContent = `فعال: Mock Offline Generator`;
        }
    }

    async function setAiProvider(provider) {
        try {
            const res = await fetch('/api/v1/admin/ai-provider', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ provider })
            });

            if (res.ok) {
                const data = await res.json();
                if (data.status) {
                    updateAiProviderUI(data.status);
                } else {
                    loadAiProviderStatus();
                }
            }
        } catch (e) {
            console.error('Failed to update AI provider:', e);
        }
    }

    const btnGemini = document.getElementById('btn-provider-gemini');
    const btnGrok = document.getElementById('btn-provider-grok');
    const btnMock = document.getElementById('btn-provider-mock');

    if (btnGemini) btnGemini.addEventListener('click', () => setAiProvider('Gemini'));
    if (btnGrok) btnGrok.addEventListener('click', () => setAiProvider('Grok'));
    if (btnMock) btnMock.addEventListener('click', () => setAiProvider('Mock'));

    function renderSearchTable(items) {
        const tbody = document.getElementById('search-analytics-tbody');
        tbody.innerHTML = items.map((item, idx) => `
            <tr>
                <td>${idx + 1}</td>
                <td><strong>${item.keyword || item.query}</strong></td>
                <td>${item.count || item.frequency}</td>
                <td><span class="source-badge badge-secondary">${item.languageCode || 'fa'}</span></td>
            </tr>
        `).join('');
    }

    function renderAiLogsTable(logs) {
        const tbody = document.getElementById('ai-logs-tbody');
        tbody.innerHTML = logs.map(log => `
            <tr>
                <td>${new Date(log.timestamp || Date.now()).toLocaleTimeString()}</td>
                <td>${log.userPrompt}</td>
                <td><code>${log.citations ? log.citations.join(', ') : 'None'}</code></td>
                <td><span class="source-badge badge-active">${log.guardrailPassed ? 'Grounded & Safe' : 'Flagged'}</span></td>
            </tr>
        `).join('');
    }

    function getFallbackSearchData() {
        return [
            { query: 'چگونه دیگران را ببخشم؟', count: 342, languageCode: 'fa' },
            { query: 'آیه ۲:۲۵۵ آیت الکرسی', count: 289, languageCode: 'fa' },
            { query: 'What is the Quranic view on patience?', count: 215, languageCode: 'en' },
            { query: 'داستان حضرت موسی و فرعون', count: 184, languageCode: 'fa' },
            { query: 'Ayah about justice and honesty', count: 156, languageCode: 'en' }
        ];
    }

    function getFallbackAiData() {
        return [
            { userPrompt: 'نظر قرآن درباره صبر چیست؟', citations: ['[سوره البقرة ۲:۱۵۳]'], guardrailPassed: true, timestamp: new Date().toISOString() },
            { userPrompt: 'آیات مرتبط با بخشش کدامند؟', citations: ['[سوره آل عمران ۳:۱۳۴]'], guardrailPassed: true, timestamp: new Date().toISOString() },
            { userPrompt: 'How should I handle trials in life?', citations: ['[Surah Al-Baqarah 2:286]'], guardrailPassed: true, timestamp: new Date().toISOString() }
        ];
    }

    // Initial Load
    loadAdminData();
});
