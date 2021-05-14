<template>
  <div>
    <v-card
      color="background"
      flat
      :class="$vuetify.theme.isDark ? 'rounded-0 pa-3' : 'rounded-0 pa-3 bgm'"
    >
      <v-card-title
        class="text-sm-h5 text-xs-h6 font-weight-bold secondary--text"
        >Welcome to the DeFi Gaming World on Fantom! PLAY! Farm! Have Fun!
      </v-card-title>
      <v-card-actions>
        <router-link
          to="/exchange"
          style="text-decoration: none; color: inherit"
        >
          <v-btn color="secondary" x-large class="rounded-lg px-7"
            >Buy
            <v-img
              :src="require('../assets/DICE-COIN.png')"
              width="40"
              contain
              class="mx-3"
            />
            Farm, Play and Earn!
          </v-btn>
        </router-link>
      </v-card-actions>
    </v-card>
    <v-container>
      <div class="items">
        <div class="items__item">
          <v-card class="rounded-xl card" color="background" outlined>
            <v-img
              width="120"
              class="bg"
              :src="require('../assets/DICE-TOKEN.png')"
              contain
            />
            <v-card-title>Swap, Farm & Play</v-card-title>
            <v-list-item three-line>
              <v-list-item-content>
                <v-list-item-title class="subtitle-2"
                  >DICE to Harvest:
                </v-list-item-title>
                <v-list-item-subtitle class="grey--text"
                  >LOCKED
                </v-list-item-subtitle>
              </v-list-item-content>
            </v-list-item>
            <v-list-item three-line>
              <v-list-item-content>
                <v-list-item-title class="subtitle-2"
                  >DICE in Wallet:
                </v-list-item-title>
                <v-list-item-subtitle class="grey--text"
                  >LOCKED
                </v-list-item-subtitle>
              </v-list-item-content>
            </v-list-item>
            <v-list color="transparent">
              <v-list-item>
                <v-btn
                  rounded
                  color="#01659c"
                  elevation="0"
                  @click="unlockWallet()"
                  block
                  >{{tokenBalance}} Dice
                </v-btn>
              </v-list-item>
              <v-list-item>
                <v-btn rounded color="#01659c" elevation="0" @click="addDiceToMetaMask()" block
                  >Add DICE to metamask</v-btn
                >
              </v-list-item>
              <v-list-item>
                <v-btn rounded color="#01659c" elevation="0" @click="rewardEveryday()" block
                  >{{rewardStatus}}</v-btn
                >
              </v-list-item>
              <v-list-item>
                <v-btn rounded color="#01659c" elevation="0" @click="unlockView()" block 
                  >{{viewStatus}}
                </v-btn>
              </v-list-item>
            </v-list>
          </v-card>
        </div>
        <div class="items__item">
          <v-card class="rounded-xl card" color="background" outlined>
            <v-card-title>Announcements</v-card-title>
          </v-card>
        </div>
      </div>
      <div class="items">
        <div class="items__item">
          <v-card class="rounded-xl card" color="background" outlined>
            <v-card-title>Dice Stats</v-card-title>
            <v-list color="transparent">
              <v-list-item style="width: 100%">
                <div
                  class="primary px-3 py-2 rounded-lg"
                  style="
                    display: flex;
                    justify-content: space-between;
                    width: 100%;
                  "
                >
                  <span>Circulating Supply</span>
                  <span>{{circulateSupply}}</span>
                </div>
              </v-list-item>
              <v-list-item style="width: 100%">
                <div
                  class="px-3 py-2 rounded-lg"
                  style="
                    display: flex;
                    justify-content: space-between;
                    width: 100%;
                  "
                >
                  <span>Market Cap</span>
                  <span>{{marketCap}}</span>
                </div>
              </v-list-item>
              <v-list-item style="width: 100%">
                <div
                  class="px-3 py-2 rounded-lg"
                  style="
                    display: flex;
                    justify-content: space-between;
                    width: 100%;
                  "
                >
                  <span>Total DICE</span>
                  <span>{{circulateSupply}}</span>
                </div>
              </v-list-item>
              <v-list-item style="width: 100%">
                <div
                  class="px-3 py-2 rounded-lg"
                  style="
                    display: flex;
                    justify-content: space-between;
                    width: 100%;
                  "
                >
                  <span>New DICE/block</span>
                  <span>{{newDiceBlock}}</span>
                </div>
              </v-list-item>
            </v-list>
          </v-card>
        </div>
        <div class="items__item">
          <v-card class="rounded-xl card" color="background" outlined>
            <v-card-title>Total Value Locked (TVL)</v-card-title>
            <v-list color="transparent">
              <v-list-item>
                <v-list-item-content class="text-h3">
                  $000,000,000
                </v-list-item-content>
              </v-list-item>
              <v-list-item>
                <v-list-item-content>
                  $Across FTM DICE Farm and Pool
                </v-list-item-content>
              </v-list-item>
            </v-list>
          </v-card>
        </div>
      </div>
    </v-container>
  </div>
</template>

<script>
import { mapGetters } from "vuex";
import {SERVER_URL, SERVER_PORT, NET_URL, DICE_ADDRESS} from "../../config";

export default {
  data() {
    return {
      circulateSupply: 0,
      newDiceBlock: 0,
      marketCap: 0,
      reward: false,
      rewardStatus: "COLLECTING REWARDS"
    };
  },
  computed: {
    ...mapGetters({
      appState: 'appState',
      walletStatus: 'walletStatus',
      viewStatus: 'viewStatus',
      tokenBalance: "tokenBalance",
    }),
  },
  mounted() {
    if (this.appState.diceContract) {
      this.appState.diceContract.methods.checkReward().call().then((res) => {
        this.reward = res
        if (this.reward === false) {
          this.rewardStatus = "COLLECTING REWARDS"
        } else {
          this.rewardStatus = "CLAIMING REWARDS"
        }
      })
    }

    this.getcirculateSupply();
    this.getNewDiceBlock();
  },
  methods: {
    async unlockWallet() {
      if (typeof window.ethereum === "undefined") {
        return;
      }

      window.ethereum.request({
        method: "eth_requestAccounts",
      });
    },

    getcirculateSupply() {
        if (this.appState.diceContract) {
            this.appState.diceContract.methods
                .totalSupply()
                .call()
                .then((res) => {
                    this.circulateSupply = res;
                    this.getMarketCap();
                });
        }
    },

    getNewDiceBlock() {
        if (this.appState.diceContract) {
            const timestamp = new Date().getTime();
            this.appState.diceContract.methods
                .getMintAmount(timestamp)
                .call()
                .then((res) => {
                    this.newDiceBlock = res;
                });
        }
    },

    getMarketCap() {
      if (this.appState.diceContract) {
        this.appState.diceContract.methods
            .getReserves()
            .call()
            .then((res) => {
                const bnbReserve = Number(res.amountA) / Math.pow(10, 18);
                const diceReserve = Number(res.amountB) / Math.pow(10, 8);    
                //this.dicePrice = (bnbReserve / diceReserve).toFixed(8);
                this.marketCap = this.circulateSupply * bnbReserve / diceReserve;
            });
      }
    },

    unlockView() {
      console.log(this.walletStatus);
      //if (this.walletStatus === "CHECK WALLET") {
        const url = `${NET_URL}/${DICE_ADDRESS}`;
        window.open(url, "_blank");
        return;
      //}
    },

    async addDiceToMetaMask() {
      const tokenAddress = DICE_ADDRESS;
      const tokenSymbol = 'DICE';
      const tokenDecimals = 8;
      const tokenImage = 'http://placekitten.com/200/300';

      try {
        // wasAdded is a boolean. Like any RPC method, an error may be thrown.
        const wasAdded = await ethereum.request({
          method: 'wallet_watchAsset',
          params: {
            type: 'ERC20', // Initially only supports ERC20, but eventually more!
            options: {
              address: tokenAddress, // The address that the token is at.
              symbol: tokenSymbol, // A ticker symbol or shorthand, up to 5 chars.
              decimals: tokenDecimals, // The number of decimals in the token
              //image: tokenImage, // A string url of the token logo
            },
          },
        });

        if (wasAdded) {
          console.log('Thanks for your interest!');
        } else {
          console.log('Your loss!');
        }
      } catch (error) {
        console.log(error);
      }
    },

    rewardEveryday() {
      if (this.reward === false)
        return

      this.appState.diceContract.methods
            .getReward()
            .send({ from: this.appState.walletAddress })
            .then(() => {
            })
    }
  },
};
</script>

<style scoped>
.card {
  position: relative;
  height: 100%;
}

.bg {
  position: absolute;
  top: 70px;
  right: 30px;
  opacity: 0.4;
}

.items {
  display: flex;
  justify-content: center;
}

.items__item {
  max-width: 400px;
  width: 100%;
  margin: 20px;
}

@media (max-width: 900px) {
  .card {
    position: relative;
    height: 100%;
  }

  .items {
    display: flex;
    justify-content: center;
    flex-direction: column;
  }

  .items__item {
    max-width: 90%;
  }
}
</style>