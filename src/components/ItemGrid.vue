<template>
  <v-card class="background rounded-xl card">
    <div class="top">
      <div class="icon">
        <v-img width="60" :src="require('../assets/DICE-FMTLP.png')" />
      </div>
      <div class="right">
        <div class="font-weight-bold text-h5">DICE-FTM LP</div>
        <div class="secondary px-2 py-1 rounded-xl">BEST</div>
      </div>
    </div>
    <div class="body">
      <div class="my-3">
        <div class="secondary--text subtitle-2">DICE EARNED FROM LIQUIDITY</div>
        <div class="body__item">
          <div class="text-h4 grey--text">{{playReward}}</div>
          <div v-if="playReward < 1" class="disabled grey px-4 py-2 rounded-xl">Harvest (CLAIM DICE)</div>
          <div v-if="playReward > 0" class="enabled px-4 py-2 rounded-xl" @click="clickPlayReward()">Harvest (CLAIM DICE)</div>
        </div>
      </div>
      <div class="my-3">
        <div class="secondary--text subtitle-2">DICE EARNED FROM PLAYING</div>
        <div class="body__item">
          <div class="text-h4 grey--text">{{farmReward}}</div>
          <div v-if="farmReward < 1" class="disabled grey px-4 py-2 rounded-xl">Harvest (CLAIM DICE)</div>
          <div v-if="farmReward > 0" class="enabled px-4 py-2 rounded-xl" @click="clickFarmReward()">Harvest (CLAIM DICE)</div>
        </div>
      </div>
      <!--<div class="my-4">
        <div class="secondary--text subtitle-2">DICE-FTM LP STAKED</div>
        <v-btn
          block
          large
          rounded
          color="primary"
          class="my-2"
          @click="unlockWallet()"
          >{{farmStatus}}</v-btn
        >
        <v-btn rounded color="#01659c" elevation="0" @click="rewardEveryday()" block
          >{{rewardStatus}}</v-btn
        >
      </div>-->
    </div>
    <v-divider></v-divider>
    <v-expansion-panels flat>
      <v-expansion-panel class="transparent">
        <v-expansion-panel-header>Details</v-expansion-panel-header>
        <v-expansion-panel-content>
          <div class="body__item">
            <div>Total DICE Rewards:</div>
            <div>{{totalDiceReward}}</div>
          </div>
          <div class="body__item">
            <div>Total Liquidity:</div>
            <div>{{totalPool}} FTM</div>
          </div>
          <!--<div class="body__item">
            <div>User Liquidity Pool:</div>
            <div>{{currentPercent}}%</div>
          </div>-->
          <div class="body__item">
              <div>YOUR LP SHARE:</div>
              <div>{{currentPercent}}</div>
          </div>
        </v-expansion-panel-content>
      </v-expansion-panel>
    </v-expansion-panels>
    <v-dialog v-model="dialog" width="500">
      <v-card class="rounded-xl card" color="background" flat elevation="0">
        <v-app-bar flat color="rgba(0, 0, 0, 0)">
          <v-toolbar-title class="title white--text pl-0">
            Add to Farm
          </v-toolbar-title>
          <v-spacer></v-spacer>
          <v-btn icon @click="dialog = false">
            <v-icon>mdi-close</v-icon>
          </v-btn>
        </v-app-bar>
        <v-card-text>
          Error Message.
        </v-card-text>
      </v-card>
    </v-dialog>
  </v-card>
</template>

<script>
import { mapGetters } from "vuex";
export default {
  data() {
    return {
      dialog: false,
      reward: false,
      farmReward: 0,
      playReward: 0,
      currentPercent: 0,
      totalDiceReward: 0,
      rewardStatus: "COLLECTING REWARDS"
    };
  },
  computed: {
    ...mapGetters({
      appState: 'appState',
      farmStatus: 'farmStatus',
      totalPool: 'totalPool'
    }),
  },
  mounted() {
    if (this.appState.diceContract) {
      /*this.appState.diceContract.methods.checkReward().call().then((res) => {
        this.reward = res
        if (this.reward === false) {
          this.rewardStatus = "COLLECTING REWARDS"
        } else {
          this.rewardStatus = "CLAIMING REWARDS"
        }
      })*/

      this.getSharePercent();
      this.getDiceRewards();

      setInterval(() => {
        this.checkPlayReward();
        this.checkFarmReward();
      }, 1000);
    }
  },
  methods: {
    unlockWallet() {
      if (typeof window.ethereum === "undefined") {
        return;
      }

      window.ethereum.request({
        method: "eth_requestAccounts",
      });
    },
    rewardEveryday() {
      if (this.reward === false)
          return

      this.appState.diceContract.methods
            .getReward()
            .send({ from: this.appState.walletAddress })
            .then((res) => {
              console.log(res)
            })
    },
    getSharePercent() {
      this.appState.diceContract.methods
        .getLiquidity(this.appState.walletAddress)
        .call()
        .then((myPool) => {
          console.log(this.totalPool);
          if(this.totalPool == 0) {
            this.currentPercent = '~';
          } else {
            this.currentPercent = (myPool * 100) / this.totalPool + '%';
          }
        });
    },
    getDiceRewards() {
        if (this.appState.diceContract) {
            this.appState.diceContract.methods
                .totalSupply()
                .call()
                .then((res) => {
                    this.totalDiceReward = res - 5000000000000000;
                });
        }
    },
    checkPlayReward() {
      if (this.appState.diceContract) {
        this.appState.diceContract.methods
            .checkPlayReward()
            .call()
            .then((res) => {
                console.log(res)
                this.playReward = res;
            });
      }
    },
    checkFarmReward() {
      if (this.appState.diceContract) {
        this.appState.diceContract.methods
            .checkFarmReward()
            .call()
            .then((res) => {
                console.log(res)
                this.farmReward = res;
            });
      }
    },
    clickPlayReward() {
      if (this.appState.diceContract) {
        this.appState.diceContract.methods
            .getPlayReward()
            .call()
            .then((res) => {
                console.log(res)
            });
      }
    },
    clickFarmReward() {
      if (this.appState.diceContract) {
        this.appState.diceContract.methods
            .getFarmReward()
            .call()
            .then((res) => {
                console.log(res)
            });
      }
    }
  },
};
</script>

<style scoped>
.card {
  box-sizing: border-box;
  padding: 25px;
}
.top {
  display: flex;
  justify-content: space-between;
}
.top .icon {
}
.top .right {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
}

.body {
}
.body__item {
  width: 100%;
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.enabled {
  border-color: rgb(1, 101, 156);
  background-color: rgb(1, 101, 156);
  cursor: pointer;
}
</style>