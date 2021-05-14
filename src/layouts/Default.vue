<template>
    <v-app>
        <v-navigation-drawer
                v-model="drawer"
                :mini-variant.sync="mini"
                app
                clipped
                hide-overlay
                mobile-breakpoint="600"
                color="background"
        >
            <v-list dense nav>
                <v-list-item
                        v-for="(item, index) in items"
                        :key="`${index}-${item.title}`"
                        link
                        :to="item.link"
                >
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
                    <template v-for="(item, index) in help.children">
                        <v-list-item
                                :key="`${index}-${item.title}`"
                                link
                                :to="{path:item.link}"
                                v-if="item.title === 'FAQ'"
                        >
                            <v-list-item-icon></v-list-item-icon>
                            <v-list-item-content>
                                <v-list-item-title v-text="item.title"/>
                            </v-list-item-content>
                        </v-list-item>
                        <v-list-item
                                :key="`${index}-${item.title}`"
                                link
                                :href="item.link"
                                v-else
                        >
                            <v-list-item-icon></v-list-item-icon>
                            <v-list-item-content>
                                <v-list-item-title v-text="item.title"/>
                            </v-list-item-content>
                        </v-list-item>
                    </template>

                </v-list-group>
            </v-list>
            <template v-slot:append>
                <div class="pa-2">
                    <v-divider></v-divider>
                    <div
                            v-if="!mini"
                            class="py-2"
                            style="display: flex; align-items: center"
                    >
                        <div class="font-weight-bold">DICE: $0.001</div>
                        <v-spacer/>
                        <v-btn icon small>
                            <a href="https://twitter.com/CryptoDiceGame" target="blank"><v-icon>mdi-twitter</v-icon></a>
                        </v-btn>
                        <v-btn icon small>
                            <a href="https://t.me/CryptoDiceGame" target="blank"><v-icon>mdi-telegram</v-icon></a>
                        </v-btn>
                    </div>
                    <v-btn @click="modeTigger" block plain>
                        <v-icon dark>mdi-brightness-4</v-icon>
                    </v-btn>
                </div>
            </template>
        </v-navigation-drawer>
        <v-app-bar app clipped-left color="background">
            <v-app-bar-nav-icon @click.stop="drawerTigger" >
                <v-icon>mdi-menu-open</v-icon>
            </v-app-bar-nav-icon>
            <v-toolbar-title v-if="$vuetify.breakpoint.width > 600">
                <router-link to="/" style="text-decoration: none; color: inherit;">
                    <v-img
                            :src="$vuetify.theme.isDark ? logo.light : logo.dark"
                            alt="logo"
                            width="160px"
                    />
                </router-link>
            </v-toolbar-title>
            <v-spacer/>
            <v-btn rounded color="primary" @click="connectWallet()" small>{{
                getWalletAdrAbbr
                }}
            </v-btn>
        </v-app-bar>
        <v-main>
            <router-view/>
            <v-dialog v-model="dialog" width="500">
                <v-card class="rounded-xl card" color="background" flat>
                    <v-app-bar flat color="rgba(0, 0, 0, 0)">
                        <v-toolbar-title class="title white--text pl-0">
                            Alert
                        </v-toolbar-title>
                        <v-spacer></v-spacer>
                        <v-btn icon @click="alertMessage('', false)">
                            <v-icon>mdi-close</v-icon>
                        </v-btn>
                    </v-app-bar>
                    <v-card-text>
                        {{ alertMsg }}
                    </v-card-text>
                </v-card>
            </v-dialog>
        </v-main>
    </v-app>
</template>
<script>
    import {mapMutations, mapGetters} from "vuex";
    import Web3 from "web3";
    import {
        DICE_ADDRESS,
        DICE_ABI,
        CUSTOM_NETWORK,
        SERVER_URL,
        SERVER_PORT,
    } from "../../config";

    export default {
        data: () => ({
            drawer: false,
            mini: false,
            logo: {
                light: require("../assets/logo_light.png"),
                dark: require("../assets/logo_dark.png"),
            },
            items: [
                {title: "Home", icon: "mdi-home", link: "/"},
                {title: "Play Game", icon: "mdi-store", link: "/playgame"},
                {title: "Exchange", icon: "mdi-swap-horizontal", link: "/exchange"},
                {title: "Liquidity", icon: "mdi-swap-horizontal", link: "/liquidity"},
                {title: "Farming", icon: "mdi-bike", link: "farming"},
            ],
            help: {
                title: "Help",
                icon: "mdi-dots-horizontal",
                children: [
                    { title: "FAQ", link: "/faq" },
        { title: "Reddit", link: "https://www.reddit.com/r/CryptoDice/" },
        { title: "Medium", link: "https://medium.com/@dice.game" },
        { title: "Announcements", link: "https://t.me/CryptoDiceGame" },
        { title: "Telegram", link: "https://t.me/CryptoDiceGame" },
        { title: "Twitter", link: "https://twitter.com/CryptoDiceGame" },
                ],
            },
            web3: new Web3(Web3.givenProvider),
            diceContract: null,
            walletAddress: "CONNECT",
            netConnect: false,
            callInterval: null,
        }),
        computed: {
            getWalletAdrAbbr() {
                if (this.walletAddress !== "CONNECT")
                    return 'CONNECTED'
                else return "CONNECT";
            },

            ...mapGetters({
                alertMsg: "alertMsg",
                dialog: "alert",
            }),
        },
        async created() {
            if (this.$vuetify.breakpoint.width > 600) {
                this.drawer = true;
            }

            if (window.ethereum) {
                this.web3 = new Web3(window.ethereum);
                window.ethereum
                    .request({
                        method: "wallet_addEthereumChain",
                        params: [CUSTOM_NETWORK],
                    })
                    .catch((error) => console.log(error.message));
            } else if (window.web3) {
                this.web3 = new Web3(web3.currentProvider);
            } else {
                var msg =
                    "Please install MetaMask Extension to Play!";
                this.alertMessage(msg);
                return;
            }

            this.diceContract = new this.web3.eth.Contract(DICE_ABI, DICE_ADDRESS);

            if (typeof window.ethereum === "undefined") {
                return;
            }

            window.ethereum.on("chainChanged", (chainId) => {
                if (chainId !== CUSTOM_NETWORK.chainId) {
                    var msg = "It's a wrong network, not " + CUSTOM_NETWORK.chainName;
                    this.alertMessage(msg);
                    this.bscConnect = false;
                } else {
                    this.bscConnect = true;
                }
                this.changeWalletInfo();

                if (this.walletAddress !== "CONNECT") {
                    this.getBalance();
                }
            });

            window.ethereum.on("accountsChanged", (accounts) => {
                if (accounts[0]) {
                    this.walletAddress = accounts[0];
                    this.changeWalletInfo();
                    this.getBalance();
                } else {
                    this.walletAddress = "CONNECT";
                    this.changeWalletInfo();
                    this.getBalance();
                }
            });

            window.ethereum
                .request({
                    method: "eth_accounts",
                })
                .then((accounts) => {
                    this.walletAddress =
                        accounts.length <= 0 ? "CONNECT" : accounts[0];
                    if (accounts.length > 0) {
                        if (window.ethereum.chainId === CUSTOM_NETWORK.chainId) {
                            this.bscConnect = true;
                        }

                        this.changeWalletInfo();
                        this.getBalance();
                        //this.callInterval = setInterval(this.getBalance, 2500);
                    }
                });
        },
        methods: {
            ...mapMutations(["chageState", "getBalance"]),
            changeWalletInfo() {
                var walletState = {
                    web3: this.web3,
                    walletAddress: this.walletAddress,
                    bscConnect: this.bscConnect,
                    diceContract: this.diceContract,
                };
                this.chageState(walletState);
            },
            alertMessage(msg, show = true) {
                var msgState = {
                    alertMsg: msg,
                    alert: show,
                };
                this.chageState(msgState);
            },
            async connectWallet() {
                if (typeof window.ethereum === "undefined") {
                    return
                }

                if (this.walletAddress !== "CONNECT") {
                    var url = "https://ftmscan.com";
                    window.open(url, "_blank");
                    return;
                }

                const chainId = await this.getChainId();
                if (chainId !== CUSTOM_NETWORK.chainId) {
                    var msg = "It's a wrong network, not " + CUSTOM_NETWORK.chainName;
                    this.alertMessage(msg);
                    this.bscConnect = false;
                    return;
                }

                window.ethereum
                    .request({
                        method: "eth_requestAccounts",
                    })
                    .then(() => {
                        this.getBalance();
                        //this.callInterval = setInterval(this.getBalance, 2500);
                    });
            },
            async getChainId() {
                const chainId = await window.ethereum.request({method: "eth_chainId"});
                return chainId;
            },
            modeTigger() {
                this.$vuetify.theme.dark = !this.$vuetify.theme.dark;
            },
            drawerTigger() {
                if (this.$vuetify.breakpoint.width > 600) {
                    console.log("desktop");
                    this.mini = !this.mini;
                } else {
                    console.log("mobile");
                    this.mini = false;
                    this.drawer = !this.drawer;
                }
            },
        },
    };
</script>
<style>
    .bgm {
        background: rgba(0, 0, 0, 0) linear-gradient(139.73deg, rgb(230, 253, 255) 0%, rgb(243, 239, 255) 100%) repeat scroll 0% 0%;
    }
</style>