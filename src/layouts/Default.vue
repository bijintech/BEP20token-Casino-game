<template>
    <v-app>
        <v-navigation-drawer v-model="drawer" :mini-variant.sync="mini" app clipped hide-overlay mobile-breakpoint="600"
                             color="background">
            <v-list dense nav>
                <v-list-item v-for="(item, index) in items" :key="`${index}-${item.title}`" link :to="item.link">
                    <v-list-item-icon>
                        <v-icon>{{ item.icon }}</v-icon>
                    </v-list-item-icon>
                    <v-list-item-content>
                        <v-list-item-title>{{ item.title }}</v-list-item-title>
                    </v-list-item-content>
                </v-list-item>
                <v-list-group :value="true" :prepend-icon="help.icon">
                    <template v-slot:activator>
                        <v-list-item-title>{{ help.title }}</v-list-item-title>
                    </template>
                    <v-list-item v-for="(item, index) in help.children" :key="`${index}-${item.title}`" link
                                 :href="item.link">
                        <v-list-item-icon>
                        </v-list-item-icon>
                        <v-list-item-content>
                            <v-list-item-title v-text="item.title"/>
                        </v-list-item-content>
                    </v-list-item>
                </v-list-group>
            </v-list>
            <template v-slot:append>
                <div class="pa-2">
                    <v-divider></v-divider>
                    <div v-if="!mini" class="py-2" style="display: flex; align-items: center;">
                        <div class="font-weight-bold">DICE: $0.00</div>
                        <v-spacer/>
                        <v-btn icon small>
                            <v-icon>mdi-twitter</v-icon>
                        </v-btn>
                        <v-btn icon small>
                            <v-icon>mdi-telegram</v-icon>
                        </v-btn>
                    </div>
                    <v-btn @click="modeTigger" block plain>
                        <v-icon dark>mdi-brightness-4</v-icon>
                    </v-btn>
                </div>
            </template>
        </v-navigation-drawer>
        <v-app-bar app clipped-left color="background">
            <v-app-bar-nav-icon @click.stop="drawerTigger"></v-app-bar-nav-icon>
            <v-toolbar-title v-if="$vuetify.breakpoint.width > 600">
                <v-img :src="$vuetify.theme.isDark ? logo.light : logo.dark" alt="logo" width="160px"/>
            </v-toolbar-title>
            <v-spacer/>
            <v-btn rounded color="primary" small>Connect</v-btn>
        </v-app-bar>
        <v-main>
            <router-view/>
        </v-main>
    </v-app>
</template>
<script>

    export default {
        data: () => ({
            drawer: false,
            mini: false,
            logo: {
                light: require('../assets/logo_light.png'),
                dark: require('../assets/logo_dark.png'),
            },
            items: [
                {title: 'Home', icon: 'mdi-home', link: '/'},
                {title: 'Play Game', icon: 'mdi-store', link: '/playgame'},
                {title: 'Exchange', icon: 'mdi-swap-horizontal', link: '/exchange'},
                {title: 'Liquidity', icon: 'mdi-swap-horizontal', link: '/liquidity'},
                {title: 'Farming', icon: 'mdi-bike', link: 'farming'},
            ],
            help: {
                title: 'Help',
                icon: 'mdi-dots-horizontal',
                children: [
                    {title: 'FAQ', link: '/faq'},
                    {title: 'Reddit', link: 'https://reddit.com/r/dicegameofficial'},
                    {title: 'Medium', link: 'https://medium.com/@dice.game'},
                    {title: 'Announcements', link: 'https://t.me/dicegameofficial'},
                    {title: 'Telegram', link: 'https://t.me/dicegameofficial'},
                    {title: 'Twitter', link: 'https://t.me/dicegameofficial'}
                ]
            }
        }),
        methods: {
            modeTigger() {
                this.$vuetify.theme.dark = !this.$vuetify.theme.dark;
            },
            drawerTigger() {
                if (this.$vuetify.breakpoint.width > 600) {
                    console.log('desktop');
                    this.mini = !this.mini;
                } else {
                    console.log('mobile');
                    this.mini = false;
                    this.drawer = !this.drawer;
                }
            }
        },
        created() {
            if (this.$vuetify.breakpoint.width > 600) {
                this.drawer = true
            }
        }
    }
</script>
<style>
    .bgm {
        background: rgba(0, 0, 0, 0) linear-gradient(139.73deg, rgb(230, 253, 255) 0%, rgb(243, 239, 255) 100%) repeat scroll 0% 0%
    }
</style>