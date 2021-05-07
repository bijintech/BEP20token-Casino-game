import Vue from 'vue';
import Vuetify from 'vuetify/lib/framework';

Vue.use(Vuetify);

export default new Vuetify({
    theme: {
        dark: true,
        themes: {
            light: {
                primary: '#01659c',
                secondary: '#52d784',
                accent: '#82B1FF',
                error: '#FF5252',
                info: '#10384e',
                success: '#4CAF50',
                warning: '#FFC107',
                background: '#ffffff',
                
            },
            dark: {
                primary: '#01659c',
                secondary: '#52d784',
                accent: '#82B1FF',
                error: '#FF5252',
                info: '#10384e',
                success: '#4CAF50',
                warning: '#FFC107',
                background: '#102635'
            },
        }
    }
});
